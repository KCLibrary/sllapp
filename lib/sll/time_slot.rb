module Sll
  class TimeSlot
    
    attr_accessor :hour, :availability
    def initialize(hour, availability = false)
      @hour, @availability = hour, availability
    end  
    
  end
end
