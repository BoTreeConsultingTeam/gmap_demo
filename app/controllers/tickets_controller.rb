class TicketsController < ApplicationController
  def create
    customer = Customer.find(ticket_params["customer_id"])
    if customer
      customer.raise_ticket
      if customer.errors.blank?
        flash[:notice] = "Ticket created successfully"
      else
        flash[:error] = "Unable to create ticket."
      end
      redirect_to root_path
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:customer_id)
  end
end
