require 'sll/time_functions'

class Reservation < ActiveRecord::Base
  
  include Sll::TimeFunctions

  belongs_to :user
  belongs_to :resource
  
  attr_accessible :description, :end_datetime, :start_datetime, :resource_id, :user_id
    
  validate :must_not_exceed_licenses
  validate :length_must_be_less_than_three_hours
  validate :end_datetime_must_be_in_future
  
  validates :user, :presence => true
  validates :resource, :presence => true
  
  delegate :uid, :to => :user, :allow_nil => true, :prefix => true
  
  after_save :create_active_directory_reservation
  after_destroy :destroy_active_directory_reservation
 
  scope :overlap, lambda {|st, et|
    where{
      (start_datetime < et) & (end_datetime > st)
    }
  }
  
  
  def length
    ((end_datetime - start_datetime) / 1.day).to_i
  end
  
  def queue_name
    "q-#{id}"
  end
  
  def time_slot
    start_datetime..end_datetime
  end
  
  def time_slot_hours
    @_time_slot_hours ||= iterate_between(start_datetime, end_datetime)
  end
  
  def start_date_long_formatted_string
    self.start_datetime.to_date.to_formatted_s(:long)
  end
  
  def time_slot_dashed_formatted_string
    [ self.start_datetime.strftime("%I:%M%p"), 
      self.end_datetime.strftime("%I:%M%p") ].join(" &ndash; ")
  end
  
  private
    
  def end_datetime_must_be_in_future
    if self.end_datetime <= Time.zone.now
      errors.add(:base, 'Reservations must end in the future')
    end
  end
  
  def length_must_be_less_than_three_hours
    if (self.end_datetime - self.start_datetime) > 3.hours
      errors.add(:base, 'Reservations cannot last more than 3 hours')
    end
  end
  
  def must_not_exceed_licenses
    count = Reservation.where({
      :resource_id => self.resource_id
    }).overlap(self.start_datetime, self.end_datetime).count    
    if count > Resource._find_by_id(self.resource_id).licenses
      errors.add(:base, 'No licenses left for time')
    end
  end
  
  def create_active_directory_reservation
    AdHelper::Reservation.new(self).create_and_delete
  end
  
  def destroy_active_directory_reservation
    AdHelper::Reservation.new(self).delete_now
  end
  
end
