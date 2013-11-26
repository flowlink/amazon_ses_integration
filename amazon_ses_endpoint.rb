Dir['./lib/**/*.rb'].each(&method(:require))

class AmazonSesEndpoint < EndpointBase
  set :logging, true

  post '/send_email' do
    begin
      code = 200
      response = Processor.send_email! @config, email_hash
    rescue => e
      code = 500
      response = error_notification(e)
    end
    process_result code, base_msg.merge(response)
  end

  private
  def email_hash
    @message[:payload][:email] or raise InvalidArguments, 'Email hash must be provided'
  end

  def message_id
    @message[:message_id]
  end

  def base_msg
    { 
      'message_id' => message_id
    }
  end

  def error_notification(e)
    { notifications:
      [
        {
          level: 'error',
          subject: "#{e.class}: #{e.message.strip}",
          description: "#{e.class}: #{e.message.strip}",
          backtrace: e.backtrace.to_a.join('\n\t')
        }
      ]
    }
  end
end