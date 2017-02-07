class Customer < ActiveRecord::Base
  has_many :tickets
  has_many :service_engineers, through: :tickets
  validates :name, :address, :latitude, :longitude, presence: true
  ALL_SLOTS = ["09 AM", "10 AM", "11 AM","12 PM","01 PM","02 PM","03 PM","04 PM","05 PM","06 PM"]
  FIRST_SLOT = "09 AM"
  def raise_ticket
    ticket = tickets.build(status: 'open', raised_at: Time.now)
    sorted_unassigned_service_engineers = ServiceEngineer.all_unassigned_engineers(self)
    sorted_nearby_tickets = Ticket.nearby_tickets(self)
    allocated_slot = ''
    sorted_nearby_tickets.each do |nearby_ticket|
      @search_finish = false
      @se = ServiceEngineer.find(nearby_ticket[:se_id])
      if @se.tickets.present? && @se.tickets.count < 9
        slots = @se.tickets.map(&:allocated_slot)
        allocated_slots = slots.map{|slot|slot.strftime('%I %p')} || []
        available_slots = ALL_SLOTS - allocated_slots
        next_available_slots =[]
        available_slots.each do |sl|
          next_available_slots << sl if future_slot?(sl, ticket)
        end
        if next_available_slots.present?
          allocated_slot = Time.parse(next_available_slots.first)
          @search_finish = true
        end
      end
      break if @search_finish
    end

    if !@search_finish
      @se = ServiceEngineer.find(sorted_unassigned_service_engineers.first[:se_id])
      available_slots = []

      ALL_SLOTS.each do |sl|
        available_slots << sl if future_slot?(sl, ticket)
      end
      allocated_slot =
        if available_slots.present?
          Time.parse(available_slots.first)
        else
          allocated_slot = Time.parse(FIRST_SLOT)
        end
    end

    service_engineer_id = @se.id
    ticket.allocated_slot = allocated_slot
    if ticket.save
      service_engineer_ticket = ServiceEngineersTicket.new(ticket_id: ticket.id, service_engineer_id: service_engineer_id)
      unless service_engineer_ticket.save
        errors.add(:base, "Unable to assign service engineer.")
      end
    else
      errors.add(:base, "Unable to create ticket.")
    end
  end

  private

  def future_slot?(slot, ticket)
    Time.parse(slot).hour > ticket.raised_at.hour
  end
end
