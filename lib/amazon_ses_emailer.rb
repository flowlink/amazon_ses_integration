require './lib/amazon_ses_config'

class AmazonSesEmailer < AmazonSesConfig

  def send! email_hash
    ses.send_email(email_hash)
  end
end
