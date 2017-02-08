module ApplicationHelper
  def customers_for_select
    Customer.all.collect { |m| [m.name, m.id] }
  end

  def format_slot_time(ticket)
    slot_time = ticket.allocated_slot
    slot_time.strftime("%D at %H:%M to #{(slot_time + 1.hour).strftime("%H:%M")}")
  end

  def close_ticket_marker(img)
    asset_url(img)
  end
end
