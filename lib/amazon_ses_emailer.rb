require 'pry'
require './lib/amazon_ses_config'

class AmazonSesEmailer < AmazonSesConfig

  def send! email_hash
    validate_email_hash!(email_hash)

    ses.send_email(email_hash)
    binding.pry
  end

  private 
  def validate_email_hash! h
    raise InvalidArguments if h[:to].blank? or h[:from].blank? or h[:subject].blank? or (h[:body_html].blank? and h[:body_text].blank?)
  end
end
