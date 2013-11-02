class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :store_location

  def store_location
    session[:previous_url] = request.fullpath unless request_is_for_users?
    unless request_is_for_users? || request_is_for_reservations_new_get?
      session['reservation-times'] = params['reservation-times'] 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
  
  private
  
  def request_is_for_users?
    request.fullpath =~ /\/users/
  end
  
  def request_is_for_reservations_new_get?
    request.fullpath =~ /\/reservations\/new/ && request.method == "GET"
  end
  
end
