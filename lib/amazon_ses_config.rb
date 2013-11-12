require './lib/errors'

class AmazonSesConfig
  attr_accessor :access_key_id, :secret_access_key, :ses

  def initialize config
    @access_key_id = config['amazon_ses.access_key_id']
    @secret_access_key = config['amazon_ses.secret_access_key']

    validate!
    
    AWS.config(access_key_id: access_key_id, secret_access_key: secret_access_key)
    @ses = AWS::SimpleEmailService.new
  end

  private
  def validate!
    raise AuthorizationError, "Amazon access key ID and secret access key must be provided" if (access_key_id.blank? or secret_access_key.blank?)
  end
end
