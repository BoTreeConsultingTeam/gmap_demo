class Ticket < ActiveRecord::Base
  belongs_to :customer
  has_and_belongs_to_many :service_engineers, allow_nil: true
end
