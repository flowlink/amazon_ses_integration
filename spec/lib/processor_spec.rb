require 'spec_helper'

describe Processor do
  let (:config) { Factory.processed_config }
  let (:email_hash) { Factory.payload[:email] }

  it 'returns info notification' do
    VCR.use_cassette('send_email_success') do
      ret = described_class.send_email!(config, email_hash)

      ret.should be_kind_of(Hash)
      ret[:notifications].first[:level].should eq('info')
      ret[:notifications].first[:subject].should match('Successfully sent an email to')
      ret[:notifications].first[:description].should match('Successfully sent an email to')
    end
  end
end
