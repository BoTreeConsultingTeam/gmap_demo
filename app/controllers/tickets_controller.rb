class TicketsController < ApplicationController
  def create
    all_slots = ["09 AM", "10 AM", "11 AM","12 PM","01 PM","02 PM","03 PM","04 PM","05 PM","06 PM"]
    customer = Customer.find(ticket_params["customer_id"])
    if customer
      all_ses = ServiceEngineer.all
      unassigned_service_engineers = []
      nearby_tickets = []
      all_ses.each do |se|
        distance_in_mile = Geocoder::Calculations.distance_between([customer.latitude, customer.longitude], [se.latitude, se.longitude])
        unassigned_service_engineers << { distance: distance_in_mile * 1.60934, se_id: se.id}
      end

      ticket = customer.tickets.build(status: 'open', raised_at: Time.zone.now)
      tickets = Ticket.includes(:customer).where(status: 'open')
      tickets_locations = tickets.map{|ticket| { latitude: ticket.customer.latitude, longitude: ticket.customer.longitude, se_id: ticket.service_engineers.first.id}}

      tickets_locations.each do |ticket_hash|
        distance_in_mile = Geocoder::Calculations.distance_between([customer.latitude, customer.longitude], [ticket_hash[:latitude], ticket_hash[:longitude]])
        nearby_tickets << { distance: (distance_in_mile * 1.60934), se_id: ticket_hash[:se_id]}
      end

      sorted_unassigned_service_engineers = unassigned_service_engineers.sort_by { |k| k[:distance] }
      sorted_nearby_tickets = nearby_tickets.sort_by { |k| k[:distance] }
      allocated_slot = ''
      sorted_nearby_tickets.each do |nearby_ticket|
        search_finish = false
        @se = ServiceEngineer.find(nearby_ticket[:se_id])
        if @se.tickets.present? && @se.tickets.count < 9
          slots = @se.tickets.map(&:allocated_slot)
          allocated_slots = slots.map{|slot|slot.strftime('%I %p')} || []
          available_slots = all_slots - allocated_slots
          next_available_slots =[]
          available_slots.each do |sl|
            next_available_slots << sl if Time.zone.parse(sl).hour > ticket.raised_at.hour
          end

          if next_available_slots.present?
            allocated_slot = Time.zone.parse(next_available_slots.first)
            search_finish = true
          end
        end
        break if search_finish
      end

      if @se.blank?
        @se = ServiceEngineer.find(sorted_unassigned_service_engineers.first[:se_id])
        available_slots =[]
        all_slots.each do |sl|
          available_slots << sl if Time.zone.parse(sl).hour > ticket.raised_at.hour
        end

        if available_slots.present?
          allocated_slot = Time.zone.parse(available_slots.first)
        else
          allocated_slot = Time.zone.parse("09 AM")
        end
      end

      # service_engineer_id = sorted_unassigned_service_engineers.first[:se_id]
      service_engineer_id = @se.id
      ticket.allocated_slot = allocated_slot

      if ticket.save
        ServiceEngineersTicket.create(ticket_id: ticket.id, service_engineer_id: service_engineer_id)
        flash[:notice] = "Ticket created successfully"
      else
        flash[:error] = ticket.errors.full_messages
      end
      redirect_to root_path
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:customer_id)
  end
end
