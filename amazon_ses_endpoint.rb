require "sinatra"
require "endpoint_base"

Dir['./lib/**/*.rb'].each(&method(:require))

class AmazonSesEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/send_email' do
    begin
      result 200, Processor.send_email!(@config, email_hash)
    rescue => e
      result 500, e.message
    end
  end

  private
  def email_hash
    @payload[:email] or raise InvalidArguments, 'Email hash must be provided'
  end
end
