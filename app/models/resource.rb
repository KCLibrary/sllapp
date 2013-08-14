class Resource < ActiveRecord::Base
  attr_accessible :description, :type
	has_many :reservations
 
  def self.first_available(st, et)
    where{
      id << Reservation.overlap(st, et).select(:resource_id)
    }.first
  end
	
end
