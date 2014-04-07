require 'spec_helper'

describe AmazonSesEndpoint do

  let(:message) {
    Factory.payload({:parameters => Factory.config})
  }

  def app
    AmazonSesEndpoint
  end

  it 'sends e-mail' do
    VCR.use_cassette('send_email_success') do
      post '/send_email', message.to_json, auth

      last_response.status.should eq(200)

      last_response.body.should match("message_id")
      last_response.body.should match("notifications")
      last_response.body.should match("info")
      last_response.body.should match("Successfully sent an email to")
    end
  end

  it 'return error notification if email hash is missing' do
    message.delete(:email)

    post '/send_email', message.to_json, auth

    last_response.status.should eq(500)

    last_response.body.should match("message_id")
    last_response.body.should match("notifications")
    last_response.body.should match("error")
    last_response.body.should match("InvalidArguments")
    last_response.body.should match("Email hash must be provided")
  end

  it 'returns error notification if subject is missing' do
    message[:email].delete(:subject)

    post '/send_email', message.to_json, auth

    last_response.status.should eq(500)

    last_response.body.should match("message_id")
    last_response.body.should match("notifications")
    last_response.body.should match("error")
    last_response.body.should match("InvalidArguments")
    last_response.body.should match("'to', 'from', 'subject', 'body' attributes are required")
  end
end
