class ReservationSlot < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :resource
  attr_accessible :end_datetime, :start_datetime, :resource_id, :reservation_id

 
  scope :overlap, lambda {|st, et|
    where{
      ((start_datetime >= st) & (start_datetime <= st)) |
      ((end_datetime >= et) & (end_datetime <= et))
    }
  }
  
  scope :unavailable_blocks, lambda { |arr|
    where(:start_datetime => arr)
    .group(:start_datetime)
    .select(:start_datetime)
    .having('count(resource_id) >= ?', Resource.count)
  }  
end
