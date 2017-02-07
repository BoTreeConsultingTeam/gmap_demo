class HomeController < ApplicationController
  def index
    @ticket = Ticket.new
    @tickets = Ticket.includes(:service_engineers, :customer).order(raised_at: :desc).paginate(:page => params[:page], :per_page => 10)
  end

  def address
    customer = Customer.find(params[:id])
    if customer
      @address = customer.address
    end
  end

  def dir_route
    @service_engineer = ServiceEngineer.includes(:tickets).find(params[:id])
    customers = @service_engineer.tickets.map(&:customer)
    @locations = customers.map{|l|[l.latitude, l.longitude]}
    @hash = Gmaps4rails.build_markers(@locations.uniq) do |ticket, marker|
      marker.lat ticket.first
      marker.lng ticket.last
    end
    @hash = @hash.to_json
  end

  def service_engineer_status
    @service_engineers = ServiceEngineer.includes(tickets: :customer).paginate(:page => params[:page], :per_page => 10)
  end
end
