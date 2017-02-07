require 'time'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Customer.destroy_all
ServiceEngineer.destroy_all
final_cords = []
base_cord = Geocoder.coordinates("Ahmedabad")

radius = (25.0/111300).to_f
30.times do
  u = rand(1..100).to_f
  v = rand(101..200).to_f

  w = radius * Math.sqrt(u)
  t = 2 * Math::PI * v
  x = (w * Math.cos(t))

  y = (w * Math.sin(t))
  new_location = [base_cord[0] + x, (base_cord[1] + y).round(10)]
  final_cords << new_location
end
final_cords.first(10).each do |location|
  geo_localization = "#{location.first},#{location.last}"
  query = Geocoder.search(geo_localization).first
  address = query.address if query.present?
  ServiceEngineer.create(name: Faker::Name.name, latitude: location.first, longitude: location.last, location: address)
end

final_cords[10..30].each do |location|
  geo_localization = "#{location.first},#{location.last}"
  query = Geocoder.search(geo_localization).first
  address = query.address if query.present?
  Customer.create(name: Faker::Name.name, latitude: location.first, longitude: location.last, address: address )
end


time = Time.now
Customer.first(10).each_with_index do |customer, index|
  count = index + 9
  ticket = customer.tickets.build(status: 'open',raised_at: time + (count).hour )
  ticket.save
end

service_engineers = ServiceEngineer.all
tickets = Ticket.all

tickets.each_with_index do |ticket, index|
    se_ticket = ServiceEngineersTicket.new(ticket_id: tickets[index], service_engineer_id: service_engineers[index])
    se_ticket.save
end
