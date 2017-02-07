class TicketsController < ApplicationController
  def create
    customer = Customer.find(ticket_params["customer_id"])
    if customer
      all_ses = ServiceEngineer.all
      compare_arr = []

      all_ses.each do |se|
        distance_in_mile = Geocoder::Calculations.distance_between([customer.latitude, customer.longitude], [se.latitude, se.longitude])
        compare_arr << { distance: distance_in_mile, se_id: se.id}
      end

      ticket = customer.tickets.build(status: 'open', raised_at: Time.now)
      tickets = Ticket.includes(:customer).where(status: 'open')
      tickets_locations = tickets.map{|ticket| { latitude: ticket.customer.latitude, longitude: ticket.customer.longitude, se_id: ticket.service_engineers.first.id}}

      tickets_locations.each do |ticket_hash|
        distance_in_mile = Geocoder::Calculations.distance_between([customer.latitude, customer.longitude], [ticket_hash[:latitude], ticket_hash[:longitude]])
        compare_arr << { distance: distance_in_mile, se_id: ticket_hash[:se_id]}
      end

      sorted = compare_arr.sort_by { |k| k[:distance] }
      service_engineer_id = sorted.first[:se_id]

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
