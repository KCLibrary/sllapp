class ReservationMailer < ActionMailer::Base
  
  default :from => "kardeiz@gmail.com"
  
  def notification(user, reservation)
    rdp_file = open(rdp_file_path) rescue %Q{
      full address:s:lendinglibrary1.arsalon.net\nprompt for credentials:i:1
    }.strip
    attachments['sll.rdp'] = rdp_file
    @user, @reservation = user, reservation
    subject = %Q{
      Software Lending Library Reservation - #{@reservation.start_date_long_formatted_string}
    }.strip
    mail(:to => 'kardeiz@gmail.com', :subject => subject)  
  end
  
end
