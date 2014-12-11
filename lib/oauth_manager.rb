class OauthManager
  def self.execute(environment: environment, client_app: client_app)
    config = YAML.load(File.open("#{Rails.root}/config/oauth.yml"))

    oauth_keys = {
      "alderaan" => {
        "client_id" => config[environment][client_app]["client_id"],
        "client_secret" => config[environment][client_app]["client_secret"],
        "oauth_protocol_base" => "http://alderaan-"
      },
      "dagobah" => {
        "client_id" => config[environment][client_app]["client_id"],
        "client_secret" => config[environment][client_app]["client_secret"],
        "oauth_protocol_base" => "http://dagobah-"
      },
      "staging" => {
        "client_id" => config[environment][client_app]["client_id"],
        "client_secret" => config[environment][client_app]["client_secret"],
        "oauth_protocol_base" => "http://staging-"
      },
      "production" => {
        "client_id" => config[environment][client_app]["client_id"],
        "client_secret" => config[environment][client_app]["client_secret"],
        "oauth_protocol_base" => "http://"
      }
    }
    
    oauth_protocol_base = oauth_keys[environment]["oauth_protocol_base"]
    
    conn = Faraday.new(:url => "#{oauth_protocol_base}oauth.togl.io:80", :ssl => {:verify => false}) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    resp = conn.post do |req|
      req.url '/oauth/authorize.json?redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=' + oauth_keys[environment]["client_id"]
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
        "client_id": "' + oauth_keys[environment]["client_id"] + '",
        "client_secret": "' + oauth_keys[environment]["client_secret"] + '",
        "redirect_uri": "urn:ietf:wg:oauth:2.0:oob"
       }'
    end
    
    oauth_token = JSON.parse(resp3.body)["access_token"]
    
    oauth_token
  end  
end
