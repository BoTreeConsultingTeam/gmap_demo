require 'time'
cords = [[43.020869,	-87.935931],
[43.033207,	-87.97513],
[42.969354,	-87.935931],
[43.056548,	-87.986969],
[42.985486,	-88.02408],
[43.06774,	-87.890727],
[43.004818,	-88.077682],
[43.031528,	-88.105866],
[43.076645,	-88.159125],
[43.108972,	-88.170756],
[43.082845,	-88.259531],
[43.237507,	-87.9787],
[42.800851,	-88.012584],
[43.228617,	-88.110369],
[43.151119,	-88.246204],
[42.763072,	-88.214256],
[43.25622,	-88.194365],
[43.060842,	-88.403708],
[42.741963,	-88.026751],
[42.688074,	-88.051473],
[43.191117,	-88.343707],
[42.934456,	-88.405374],
[43.31389,	-88.34194],
[43.317779	,-88.378986],
[42.726125	,-88.5426],
[42.796925,	-88.614484],
[43.38417,	-88.46056],
[42.505297,	-88.070639],
[42.477242,	-88.09564],
[42.63307,	-88.643714],
[43.005559	,-88.807327],
[42.925285,	-88.692603]]

Customer.destroy_all
ServiceEngineer.destroy_all

cords.first(10).each do |location|
  geo_localization = "#{location.first},#{location.last}"
  query = Geocoder.search(geo_localization).first
  address = query.address if query.present?
  ServiceEngineer.create(name: Faker::Name.name, latitude: location.first, longitude: location.last, location: address)
end

cords[10..30].each do |location|
  geo_localization = "#{location.first},#{location.last}"
  query = Geocoder.search(geo_localization).first
  address = query.address if query.present?
  Customer.create(name: Faker::Name.name, latitude: location.first, longitude: location.last, address: address )
end
