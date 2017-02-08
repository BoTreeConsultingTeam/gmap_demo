class Customer < ActiveRecord::Base
  has_many :tickets
  has_many :service_engineers, through: :tickets
  validates :name, :address, :latitude, :longitude, presence: true

  ALL_SLOTS = ["09 AM", "10 AM", "11 AM","12 PM","01 PM","02 PM","03 PM","04 PM","05 PM","06 PM"]
  FIRST_SLOT = "09 AM"
  TOTAL_SLOTS_OF_DAY = 9
  TIME_FORMAT = '%I %p'
  def raise_ticket
    ticket = tickets.build(status: 'open', raised_at: Time.zone.now)
    sorted_unassigned_service_engineers = ServiceEngineer.all_unassigned_engineers(self)
    sorted_nearby_tickets = Ticket.nearby_tickets(self)
    allocated_slot = ''
    sorted_nearby_tickets.each do |nearby_ticket|
      @search_finish = false
      @service_engineer = ServiceEngineer.find(nearby_ticket[:service_engineer_id])
      if @service_engineer.tickets.present? && @service_engineer.tickets.count < TOTAL_SLOTS_OF_DAY
        slots = @service_engineer.tickets.map(&:allocated_slot)
        allocated_slots = slots.map{|slot|slot.strftime(TIME_FORMAT)} || []
        available_slots = ALL_SLOTS - allocated_slots
        next_available_slots = []
        available_slots.each do |slot|
          next_available_slots << slot if future_slot?(slot,   ticket)
        end
        if next_available_slots.present?
          allocated_slot = Time.zone.parse(next_available_slots.first)
          @search_finish = true
        end
      end
      break if @search_finish
    end

    if !@search_finish
      @service_engineer = ServiceEngineer.find(sorted_unassigned_service_engineers.first[:service_engineer_id])
      available_slots = []

      ALL_SLOTS.each do |sl|
        available_slots << sl if future_slot?(sl, ticket)
      end
      allocated_slot =
        if available_slots.present?
          Time.zone.parse(available_slots.first)
        else
          Time.zone.parse(FIRST_SLOT)
        end
    end
    ticket.allocated_slot = allocated_slot
    if ticket.save
      service_engineer_ticket = ServiceEngineersTicket.new(ticket_id: ticket.id, service_engineer_id: @service_engineer.id)
      unless service_engineer_ticket.save
        errors.add(:base, "Unable to assign service engineer.")
      end
    else
      errors.add(:base, "Unable to create ticket.")
    end
  end

  private

  def future_slot?(slot, ticket)
    DateTime.parse(slot).hour > ticket.raised_at.hour
  end
end
