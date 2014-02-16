module ApplicationHelper
  ALERT_TYPES = [:danger, :info, :success, :warning, :error] unless const_defined?(:ALERT_TYPES)

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?
      
      type = :success if type == :notice
      type = :danger  if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
  
  def nav_elem(text, test_path, link_path = nil)
    link_path ||= test_path
    li_class = current_page?(test_path) ? 'active' : ''
    content_tag(:li, :class => li_class) { link_to(text, link_path) }
  end
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
end
