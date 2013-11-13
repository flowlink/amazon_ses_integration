require 'spec_helper'

describe AmazonSesEmailer do
  let (:config) { Factory.processed_config }
  let (:email_hash) { Processor.remap_email_hash(Factory.payload[:email]) }

  subject { described_class.new(config) }

  it 'raises ArgumentError error when missing subject' do
    expect {
      email_hash.delete :subject

      subject.send!(email_hash)
    }.to raise_error(ArgumentError)
  end

  it '#send! returns correct response' do
    VCR.use_cassette('send_email_success') do
      ret = subject.send!(email_hash)

      ret.should be_kind_of(AWS::Core::Response)
      ret.should have_key(:message_id)
      ret.should have_key(:response_metadata)
    end
  end
end
