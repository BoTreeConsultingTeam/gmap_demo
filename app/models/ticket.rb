class Ticket < ActiveRecord::Base
  belongs_to :customer
  has_and_belongs_to_many :service_engineers, allow_nil: true

  def current_service_engineer
    service_engineers.first
  end

  def self.nearby_tickets(customer)
    nearby_tickets = []
    open_tickets = includes(:customer).where(status: 'open')
    tickets_locations = open_tickets.map{|ticket| { latitude: ticket.customer.latitude,
      longitude: ticket.customer.longitude,
      se_id: ticket.current_service_engineer.id
      }
    }

    tickets_locations.each do |ticket_hash|
      distance_in_mile = Geocoder::Calculations.distance_between([customer.latitude, customer.longitude], [ticket_hash[:latitude], ticket_hash[:longitude]])
      nearby_tickets << { distance: (distance_in_mile), se_id: ticket_hash[:se_id]}
    end
    nearby_tickets.sort_by { |k| k[:distance] }
  end

  def self.update_status_after_finish
    all.where(status: 'open').each do |ticket|
      ticket.update_attribute(:status, "close") if Time.zone.now.hour > (ticket.allocated_slot.hour + 1)
    end
  end
end
