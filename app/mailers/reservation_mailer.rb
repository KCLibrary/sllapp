class ReservationMailer < ActionMailer::Base
  
  default :from => "kcplsllapp@gmail.com"
  
  def notification(reservation, user)
    rdp_file = %Q{
      full address:s:lendinglibrary1.arsalon.net\nprompt for credentials:i:1\ndrivestoredirect:s:*
    }.strip
    attachments['sll.rdp'] = rdp_file
    @reservation, @user = reservation, user
    subject = %Q{
      Software Lending Library Reservation - #{@reservation.start_date_long_formatted_string}
    }.strip
    mail(:to => @user.email, :subject => subject)  
  end
  
end
