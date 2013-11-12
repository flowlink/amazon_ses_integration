class Processor

  def self.send_email! config, email_hash
    emailer = AmazonSesEmailer.new config

    email_hash = remap_hash(email_hash)
    result = emailer.send!(email_hash)

    if result.class == AWS::Core::Response && result[:message_id]
      self.info_notification success_msg(email_hash[:to])
    end
  end

  private
  def self.remap_hash h
    h[:body_html] = h[:body][:html]
    h[:body_text] = h[:body][:text]

    h[:to]  = h[:to].try(:split, ',')
    h[:cc]  = h[:cc].try(:split, ',')
    h[:bcc] = h[:bcc].try(:split, ',')

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

  def self.success_msg emails
    {
      subject: "Successfully sent an email to #{emails.join(', ')} via the Amazon Simple Email Service",
      description: "Successfully sent an email to #{emails.join(', ')} via the Amazon Simple Email Service"
    }
  end
end 