module Sll
  class DailySchedule
    include TimeFunctions
    TIME_AFTER = 2.hours
    
    attr_accessor :date

    def initialize(date = Date.today)
      @date = date.to_date
    end

    def date_given_is_today?
      @date == Date.today
    end

    def start_datetime
      @start_datetime ||= if date_given_is_today? 
        DateTime.now.at_beginning_of_hour
      else @date.at_beginning_of_day end
    end

    def end_datetime
      @end_datetime ||= @date.end_of_day + TIME_AFTER
    end

    def hours_of_day
      @hours_of_day ||= iterate_between(start_datetime, end_datetime)
    end

    def availability_blocks(scope = Reservation)
      reservations = scope.overlap(hours_of_day[0], hours_of_day[-1]).group_by(&:resource_id)
      hours_of_day.map do |hour|
        a = Resource._all.inject(Hash.new) do |h, r|
          h[r.id] = !(reservations[r.id] && reservations[r.id].count {|c| c.time_slot.cover? hour } > r.licenses); h
        end
        { :hour => hour, :availability => a}
      end
    end
  end
end

  
