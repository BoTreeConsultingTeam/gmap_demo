class HomeController < ApplicationController
  def index
    Ticket.update_status_after_finish
    @ticket = Ticket.new
    @tickets = Ticket.includes(:service_engineers, :customer).where(status: 'open').order(raised_at: :desc).paginate(:page => params[:page], :per_page => 10)
  end

  def address
    customer = Customer.find(params[:id])
    if customer
      @address = customer.address
    end
  end

  def dir_route
    @service_engineer = ServiceEngineer.includes(:tickets).order('tickets.created_at DESC').find(params[:id])
    tickets = @service_engineer.tickets
    @locations = tickets.map{|l|[l.customer.latitude, l.customer.longitude]}
    @hash = Gmaps4rails.build_markers(tickets.uniq) do |ticket, marker|
      if ticket.status == 'open'
        marker.picture "green"
      else
        marker.picture ""
      end
      marker.infowindow "<b>Ticket ID: #{ticket.id}</b><br>#{ticket.customer.name}<br>#{ticket.customer.address}"
      marker.lat ticket.customer.latitude
      marker.lng ticket.customer.longitude
    end
    @hash = @hash.to_json
  end

  def customer_locations

    @hash = Gmaps4rails.build_markers(Customer.all.uniq) do |customer, marker|
      marker.lat customer.latitude
      marker.lng customer.longitude
      marker.infowindow "<b>Ticket ID: #{customer.id}</b><br>#{customer.name}<br>#{customer.address}"
    end
    @hash = @hash.to_json
  end

  def documentation
  end

  def service_engineer_status
    @service_engineers = ServiceEngineer.includes(tickets: :customer).paginate(:page => params[:page], :per_page => 10)
  end
end
