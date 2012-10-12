require 'net/smtp'

class Email < ValidatingBase
  attr_accessor :subject, :address, :message
  validates_presence_of :subject, :message => 'Please give a subject'
  validates_presence_of :message, :message => 'Please write me a message'
  validates_length_of :subject, :maximum => 255, :too_long => "Subject is too long."
  validates_length_of :address, :maximum => 255, :too_long => "Email address is too long."
  validates_format_of :address, :with => /^([-^!#$\%&*+\/=?`{|}~.\w]+@[-.a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9])*(\.[a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9])*)+)?$/i,
                                :message => "Please provide a valid email address."

  def save
    return if !self.valid?
    mess = ""
    mess << "From:\n"
    mess << "To:\n"
    mess << "Subject: " + subject + "\n"
    mess << "Reply-To: <" + address.to_s + ">\n" if !address.nil? and !address.empty?
    mess << "\n\n"
    mess << message
    
    Net::SMTP.start('', 25, '', '', '', :login) do |smtp|
      smtp.send_message mess, '', ''
    end
    return true
  end
  
end
