require 'pry'
class Processor

  def self.send_email! config, email_hash
    emailer = AmazonSesEmailer.new config

    email_hash = remap_hash(email_hash)
    result = emailer.send!(email_hash)

    if result == nil
      self.info_notification success_msg(email_hash[:email])
    end
  end

  private
  def self.remap_hash h
    h[:body_html] = h[:body][:html]
    h[:body_text] = h[:body][:text]
    h
  end

  def self.info_notification msg
    { notifications:
      [
        {
          level: "info"
        }.merge(msg)
      ]
    }
  end

  def self.success_msg email
    {
      subject: "Successfully sent an email to #{email} via the Amazon Simple Email Service",
      description: "Successfully sent an email to #{email} via the Amazon Simple Email Service"
    }
  end

  # def self.already_subscribed_msg email
  #   {
  #     subject: "#{email} is already subscribed to the MailChimp list",
  #     description: "#{email} is already subscribed to the MailChimp list"
  #   }
  # end
end 