module ApplicationHelper
  def customers_for_select
    Customer.all.collect { |m| [m.name, m.id] }
  end
end
