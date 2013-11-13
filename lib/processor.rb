class Processor

  def self.send_email! config, email_hash
    emailer = AmazonSesEmailer.new config
    
    validate_email_hash!(email_hash)
    email_hash = remap_email_hash(email_hash)

    result = emailer.send!(email_hash)

    if result.class == AWS::Core::Response && result[:message_id]
      self.info_notification_with success_msg(email_hash[:to])
    end
  end

  private
  def self.validate_email_hash! h
    if h[:to].blank? || h[:from].blank? || h[:subject].blank? || h[:body].blank?
      raise InvalidArguments, "'to', 'from', 'subject', 'body' attributes are required"
    end
  end

  def self.remap_email_hash h
    h[:body_html] = h[:body][:html]
    h[:body_text] = h[:body][:text]

    h[:to]  = h[:to].try(:split, ',')
    h[:cc]  = h[:cc].try(:split, ',')
    h[:bcc] = h[:bcc].try(:split, ',')
    
    h
  end

  def self.info_notification_with msg
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