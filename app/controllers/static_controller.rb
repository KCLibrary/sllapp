class StaticController < ApplicationController
  def rdp_file
    contents = %Q{
      full address:s:lendinglibrary1.arsalon.net\nprompt for credentials:i:1
    }.strip
    send_data contents, :filename => 'sll.rdp'
  end
end
