module Sll
  class DailySchedule
    include TimeFunctions
    TIME_AFTER = 2.hours
    
    attr_accessor :date

    def initialize(date)
      @date = (date || Date.today).to_date
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

    def availability_blocks
      @availability_blocks ||= hours_of_day.map do |hour|
        { 
          :hour => hour, 
          :availability => Resource._all.inject(Hash.new) do |h, r|
            h[r.id] = resource_available_at_hour?(r, hour); h
          end
        }
      end
    end
    
    def reservations_by_resource_id
      @reservations_by_resource_id ||= begin
        Reservation.overlap(hours_of_day[0], hours_of_day[-1]).group_by(&:resource_id)
      end
    end
    
    def resource_available_at_hour?(resource, hour)
      return true unless reservations_by_resource_id[resource.id]
      reservations_by_resource_id[resource.id].count do |c|
        c.time_slot.cover? hour
      end <= resource.licenses
    end
    
  end
end

  
