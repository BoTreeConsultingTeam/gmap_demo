class ServiceEngineer < ActiveRecord::Base
  has_and_belongs_to_many :tickets
  has_many :customers, through: :tickets
  validates :name, :location, :latitude, :longitude, presence: true

  def self.all_unassigned_engineers(customer)
    unassigned_service_engineers = []
    all.each do |service_engineer|
      distance_in_mile = Geocoder::Calculations.distance_between([customer.latitude, customer.longitude], [service_engineer.latitude, service_engineer.longitude])
      unassigned_service_engineers << { distance: distance_in_mile, service_engineer_id: service_engineer.id}
    end
    unassigned_service_engineers.sort_by { |k| k[:distance] }
  end
end
