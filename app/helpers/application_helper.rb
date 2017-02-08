module ApplicationHelper
  def customers_for_select
    Customer.all.collect { |m| [m.name, m.id] }
  end

  def format_slot_time(ticket)
    slot_time = ticket.allocated_slot.localtime
    slot_time.strftime("%D at %I:%M%p to #{(slot_time + 1.hour).strftime("%I:%M%p")}")
  end
end
