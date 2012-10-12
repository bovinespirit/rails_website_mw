
class EmailController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  # Set @email to nil to disable emails and display apology
  def index
    @webpage = Webpage.create("email")
    @email = Email.new # nil
    render :action => 'send_email'
  end

  def send_email
    @webpage = Webpage.create("email")
    ep = params['email']
    if ep
      ep.each { | k, v | ep[k] = strip_tags(v.strip) }
      @email = Email.new(ep)
      logger.info("Subject:#{@email.subject}")
      if @email.save
        render :action => 'email_sent'
      else
        render :action => 'send_email'
      end
    else
      @email = Email.new
    end
  end
end
