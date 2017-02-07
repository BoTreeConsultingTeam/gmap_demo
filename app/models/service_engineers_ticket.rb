class ServiceEngineersTicket < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :service_engineer
end
