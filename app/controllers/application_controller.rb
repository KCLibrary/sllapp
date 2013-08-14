class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :store_location

  def store_location
    session[:previous_url] = request.fullpath unless request_is_for_users?(request)
    unless request_is_for_users?(request) || request_is_for_reservations_new_get?(request)
      session['sll-times'] = params['sll-times'] 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
  
  private
  
  def request_is_for_users?(req)
    req.fullpath =~ /\/users/
  end
  
  def request_is_for_reservations_new_get?(req)
    req.fullpath =~ /\/reservations\/new/ && req.method == "GET"
  end
  
end
