module Sll
  class TimeSlot
    
    attr_accessor :start_hour, :reservations_for_day
    
    def initialize(start_hour, reservations_for_day)
      @start_hour, @reservations_for_day = start_hour, reservations_for_day
    end
    
    def resources
      @resources ||= Resource._all.map do |resource|
        OpenStruct.new({
          :id => resource.id, :available => resource_available?(resource)
        })
      end
    end
    
    def resource_available?(resource)
      return false if start_hour < (Time.now - 1.hour)
      resource.licenses > count_for_resource(resource)
    end    
    
    def count_for_resource(resource)
      Array.wrap(reservations_by_resource_id[resource.id]).count do |r|
        r.time_slot_hours.include? start_hour
      end
    end
    
    def reservations_by_resource_id
      @reservations_by_resource_id ||= begin
        reservations_for_day.group_by(&:resource_id)
      end
    end
    
    def end_hour
      start_hour + 1.hour
    end
    
  end
end
