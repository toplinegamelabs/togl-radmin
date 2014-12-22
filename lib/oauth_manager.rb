class OauthManager
  def self.execute(client_app: client_app)
    if ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(ENV["LOCAL_TESTING_MODE"])
      execute_with_test_credentials(client_app: client_app)
    else
      execute_with_oauth(client_app: client_app)
    end
  end

  # manually override a token just for local testing
  # local rapi instance will need to have this test key in its Oauth tokens
  # note: differences between client apps will not work when using a single test token like this.
  def self.execute_with_test_credentials(client_app: client_app)
    "323TEST323"
  end

  def self.execute_with_oauth
    conn = Faraday.new(:url => "#{ENV["URL_BASE"]}oauth.togl.io:80", :ssl => {:verify => false}) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    resp = conn.post do |req|
      req.url '/oauth/authorize.json?redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=' + ENV["#{client_app.upcase}_CLIENT_ID"]
      req.headers['X-Application-Token'] = 'temp_dailymvp'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    location = resp.headers["location"]

    ### go to redirect url
    resp2 = conn.get location
    
    authorization_code = JSON.parse(resp2.body)["authorization_code"]

    ### post step 3
    resp3 = conn.post do |req|
      req.url '/oauth/token.json'
      req.headers['X-Application-Token'] = 'temp_dailymvp'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = '{
        "grant_type": "authorization_code",
        "code": "' + authorization_code + '",
        "client_id": "' + ENV["#{client_app.upcase}_CLIENT_ID"] + '",
        "client_secret": "' + ENV["#{client_app.upcase}_CLIENT_SECRET"] + '",
        "redirect_uri": "urn:ietf:wg:oauth:2.0:oob"
       }'
    end
    
    oauth_token = JSON.parse(resp3.body)["access_token"]
    
    oauth_token
  end  
end
