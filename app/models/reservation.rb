class Reservation < ActiveRecord::Base
  
  include SllTimeHelper

  belongs_to :user
  belongs_to :resource
  has_many :reservation_slots, :dependent => :destroy
  
  attr_accessible :description, :end_datetime, :start_datetime, :resource_id, :user_id
  
  before_create :create_reservation_slots
  
  validate :times_must_not_overlap
  validate :length_must_be_less_than_three_hours
  validate :end_datetime_must_be_in_future
  
  validates :user, :presence => true
  validates :resource, :presence => true
  
  scope :overlap, lambda {|st, et|
    where{
      ((start_datetime >= st) & (start_datetime <= st)) |
      ((end_datetime >= et) & (end_datetime <= et))
    }
  }
  
  def time_slot
    start_datetime..end_datetime
  end
  
  private
  
  def create_reservation_slots
    iterate_between(self.start_datetime, self.end_datetime).each do |ts|
      reservation_slots.build({ 
        :start_datetime => ts,
        :end_datetime => ts.end_of_hour,
        :resource_id => self.resource_id,
        :reservation_id => self.id
      })
    end
  end
  
  def end_datetime_must_be_in_future
    if self.end_datetime <= Time.now
      errors.add(:base, 'Reservations must end in the future')
    end
  end
  
  def length_must_be_less_than_three_hours
    if (self.end_datetime - self.start_datetime) >= 3.hours
      errors.add(:base, 'Reservations cannot last more than 3 hours')
    end
  end
  
  def times_must_not_overlap
    if Reservation.where(:resource_id => self.resource_id)
      .overlap(self.start_datetime, self.end_datetime).count > 0
      errors.add(:base, 'Reservations for a resource cannot overlap')
    end
  end
  
end
