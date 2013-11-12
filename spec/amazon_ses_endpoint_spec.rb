require 'spec_helper'

describe AmazonSesEndpoint do

  let(:message) {
    {
      'store_id' => '123229227575e4645c000001',
      'message_id' => '123229227575e4645c000002',
      'message' => 'email:send',
      'payload' => Factory.payload({:parameters => Factory.config})
    }
  }

  def app
    AmazonSesEndpoint
  end

  def auth
    {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"}
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

  it 'returns error notification if subject is missing' do
    message['payload'][:email].delete(:subject)

    post '/send_email', message.to_json, auth

    last_response.status.should eq(500)

    last_response.body.should match("message_id")
    last_response.body.should match("notifications")
    last_response.body.should match("error")
    last_response.body.should match("InvalidArguments")
    last_response.body.should match("'to', 'from', 'subject', 'body_html' or 'body_text' attributes are required")
  end
end
