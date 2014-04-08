require 'spec_helper'

describe Processor do
  let (:config) { Factory.processed_config }
  let (:email_hash) { Factory.payload[:email] }

  it 'returns info notification' do
    VCR.use_cassette('send_email_success') do
      response = described_class.send_email!(config, email_hash)
      expect(response).to match 'Successfully sent an email to'
    end
  end
end
