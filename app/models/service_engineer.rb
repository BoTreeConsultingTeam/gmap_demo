class ServiceEngineer < ActiveRecord::Base
  has_and_belongs_to_many :tickets
  has_many :customers, through: :tickets
  validates :name, :location, :latitude, :longitude, presence: true
end
