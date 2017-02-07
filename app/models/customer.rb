class Customer < ActiveRecord::Base
  has_many :tickets
  has_many :service_engineers, through: :tickets
  validates :name, :address, :latitude, :longitude, presence: true
end
