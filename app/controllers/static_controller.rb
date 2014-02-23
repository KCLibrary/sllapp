class StaticController < ApplicationController
  
  def software; end
  def about; end
  
  def home; end
  
  def rdp_file
    contents = %Q{
      full address:s:lendinglibrary1.arsalon.net\nprompt for credentials:i:1\ndrivestoredirect:s:*
    }.strip
    send_data contents, :filename => 'sll.rdp', :disposition => :inline, :type => 'application/rdp'
  end
end
