module Factory
  class << self

    def access_key_id
      'AKIAIQTUPETBD57CH4KQ'
    end

    def secret_access_key
      'MzY+7RpeUL5rq+cyJxEVU/NKyDslcPA/0O85Dp5Z'
    end

    def config
      [
        { 'name' => 'amazon_ses.access_key_id', 'value' => access_key_id },
        { 'name' => 'amazon_ses.secret_access_key', 'value' => secret_access_key }
      ]
    end

    def processed_config
      { 
        'amazon_ses.access_key_id' => access_key_id,
        'amazon_ses.secret_access_key' => secret_access_key
      }
    end

    def payload args={}
      {
        "email" => {
          "subject" => "Hello World",
          "body" => {
            "text" => "Hello World body",
            "html" => "<h1>Hello World</h1><br>body"
          },
          "to" => "andrei@spreecommerce.com",
          "from" => "andrei@spreecommerce.com",
          "cc" => "andrei@spreecommerce.com,andrei.bondarev13@gmail.com",
          "bcc" => "andrei@spreecommerce.com"
        }
      }.merge(args)
    end
  end
end