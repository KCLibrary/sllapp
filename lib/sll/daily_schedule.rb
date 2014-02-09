module Sll
  class DailySchedule
    include TimeFunctions
    TIME_AFTER = 2.hours
    
    attr_accessor :date

    def initialize(date = nil)
      @date = (date || Time.zone.now).to_date
    end

    def date_given_is_in_past?
      @date < Time.zone.now.to_date
    end

    def date_given_is_today?
      @date == Time.zone.now.to_date
    end

    def start_datetime
      @start_datetime ||= if date_given_is_today? 
        Time.zone.now.at_beginning_of_hour
      else @date.at_beginning_of_day end
    end

    def end_datetime
      @end_datetime ||= @date + 1.day + TIME_AFTER
    end

    def hours_of_day
      @hours_of_day ||= iterate_between(start_datetime, end_datetime)
    end

    def availability_blocks
      @availability_blocks ||= hours_of_day.map do |hour|
        TimeSlot.new(hour, reservations_for_day)
      end
    end    
       
    def reservations_for_day
      @reservations_for_day ||= begin
        Reservation.overlap(start_datetime, end_datetime)
      end
    end
    
  end
end

  
