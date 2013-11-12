require 'spec_helper'

describe AmazonSesConfig do
  let (:config) { Factory.processed_config }

  it 'creates valid object' do
    expect {
      instance = described_class.new(config)
      
      instance.ses.should be_kind_of(AWS::SimpleEmailService)
      instance.access_key_id.should eq(Factory.access_key_id)
      instance.secret_access_key.should eq(Factory.secret_access_key)
    }.to_not raise_error
  end

  it 'raises error when secret_access_key is missing' do
    expect {
      config.delete('amazon_ses.secret_access_key')
      instance = described_class.new(config)
    }.to raise_error AuthorizationError
  end

  it 'raises error when access_key_id is missing' do
    expect {
      config.delete('amazon_ses.access_key_id')
      instance = described_class.new(config)
    }.to raise_error AuthorizationError
  end  
end
