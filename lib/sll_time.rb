class SllTime
  include SllTimeHelper
  attr_accessor :date

  def initialize(date)
    @date = date.to_date
    @current_date = Date.today
  end

  def date_given_is_today?
    @date == @current_date
  end

  def hours_of_day
    return @hours_of_day if @hours_of_day
    start_datetime = if date_given_is_today? 
      DateTime.now.at_beginning_of_hour
    else 
      @date.at_beginning_of_day
    end
    end_datetime = @date.end_of_day + 2.hours
    @hours_of_day = iterate_between(start_datetime, end_datetime)
  end

  def hours_of_day_available
    
    return @hours_of_day_available if @hours_of_day_available
    return nil if hours_of_day.empty?
    
    # st, et = hours_of_day.first, hours_of_day.last.end_of_hour   
    unavailable = ReservationSlot.unavailable_blocks(hours_of_day).pluck(:start_datetime)
    
    @hours_of_day_available = hours_of_day.map do |hour|
      { 
        :hour => hour, 
        :available => !unavailable.include?(hour) && resource_exists?
      }
    end
    
  end

  def resource_exists?
    return @resource_exists if @resource_exists
    @resource_exists = Resource.exists?
  end

end
