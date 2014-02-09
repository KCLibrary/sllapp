class StaticController < ApplicationController
  
  def software; redirect_to :back; end
  def about; redirect_to :back; end
  
  def rdp_file
    contents = %Q{
      full address:s:lendinglibrary1.arsalon.net\nprompt for credentials:i:1\ndrivestoredirect:s:*
    }.strip
    send_data contents, :filename => 'sll.rdp'
  end
end
