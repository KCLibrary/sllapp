module Sll
  module TimeFunctions

    def iterate_between(start_datetime, end_datetime)
      if start_datetime >= end_datetime then []
      else
        iterate_between(start_datetime + 1.hour, end_datetime).unshift(start_datetime)
      end
    end
    
    def one_time_range_contains_another(container, contained)
      container.cover?(contained.first) && container.cover?(contained.last)
    end

  end
end
