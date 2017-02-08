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
      service_engineer_id: ticket.current_service_engineer.id
      }
    }

    tickets_locations.each do |ticket_hash|
      distance_in_mile = Geocoder::Calculations.distance_between([customer.latitude, customer.longitude], [ticket_hash[:latitude], ticket_hash[:longitude]])
      if distance_in_mile < ENV['MAX_DISTANCE'].to_i
        nearby_tickets << { distance: (distance_in_mile), service_engineer_id: ticket_hash[:service_engineer_id]}
      end
    end
    nearby_tickets.sort_by { |k| k[:distance] }
  end

  def self.update_status_after_finish
    all.where(status: 'open').each do |ticket|
      if (Time.zone.today > ticket.allocated_slot.to_date) ||
          (Time.zone.today == ticket.allocated_slot.to_date &&
            ((Time.zone.now - ticket.allocated_slot) > 3600))
        ticket.update_attribute(:status, "close")
      end
    end
  end
end
