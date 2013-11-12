require './lib/amazon_ses_config'

class AmazonSesEmailer < AmazonSesConfig

  def send! email_hash
    validate_email_hash!(email_hash)

    ses.send_email(email_hash)
  end

  private 
  def validate_email_hash! h
    if h[:to].blank? || h[:from].blank? || h[:subject].blank? || (h[:body_html].blank? && h[:body_text].blank?)
      raise InvalidArguments, "'to', 'from', 'subject', 'body_html' or 'body_text' attributes are required"
    end
  end
end
