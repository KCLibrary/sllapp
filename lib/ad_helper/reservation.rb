module AdHelper

  class Reservation
  
    attr_reader :app_reservation
    
    def initialize(app_reservation = nil)
      @app_reservation = app_reservation
    end
  
    def app_user
      app_reservation.user
    end
  
    def ad_user
      AdHelper::User.new(app_user)
    end    
  
    def conn
      Connector.connection
    end
  
    def create_and_delete
      create; schedule_delete
    end
  
    def create
      conn.replace_attribute ad_user.dn, :logonHours, logon_hours_formatted
    end
    handle_asynchronously :create, :run_at => Proc.new { |i|
      i.day_before_start_datetime
    }, :queue => Proc.new { |i|
      i.app_reservation.queue_name
    }
    
    def schedule_delete
      conn.replace_attribute ad_user.dn, :logonHours, logon_hours_formatted('0')
    end
    handle_asynchronously :schedule_delete, :run_at => Proc.new { |i|
      i.day_after_start_datetime
    }, :queue => Proc.new { |i|
      i.app_reservation.queue_name
    }
    
    def delete_now
      Delayed::Job.where(:queue => app_reservation.queue_name).destroy_all
      schedule_delete_without_delay
    end
    
    def day_before_start_datetime
      start_datetime - 1.day
    end
    
    def day_after_start_datetime
      start_datetime + 1.day
    end
    
    def start_datetime
      app_reservation.start_datetime
    end
    
    def fill_index
      bias = Time.now.in_time_zone('America/Chicago').dst? ? 1 : 0
      (start_datetime.utc.wday * 24) + (start_datetime.utc.hour) + bias
    end
    
    def fill_values(b)
      [b, fill_index, app_reservation.duration]
    end
    
    def logon_hours_formatted(b = '1')
      _v = ad_user.current_logon_hours.chars.to_a.fill(*fill_values(b)).join
      Connector.bin_to_code _v
    end
  
  end
end
