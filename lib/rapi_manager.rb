class RapiManager
  def initialize(opts={})
    @oauth_token = opts.fetch(:oauth_token) { raise 'oauth token required' }
  end


  def list_games
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end
  
  def list_contest_templates(game_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games/#{game_id}/contest_templates.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end

  
  def list_event_participants(game_id, contest_template_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games/#{game_id}/contest_templates/#{contest_template_id}/event_participants.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end

  def show_user_by_username(username)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_lookup.json", { username: username }
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)
  end

  def show_user_by_id(user_id)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_lookup.json", { user_id: user_id }
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)
  end

  def user_csv_list
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_list.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)
  end


  def create_promo_challenge(params)
    rapi_conn = get_connection
    json_response = rapi_conn.post do |req|
      req.url '/admin/promotional_challenge.json'
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  

  def update_promo_challenge(params)
    rapi_conn = get_connection
    json_response = rapi_conn.put do |req|
      req.url '/admin/promotional_challenge.json'
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end


  def list_promotions
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/promotions_list.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end


  def show_promotion_by_identifier(identifier)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/promotions_show.json", { identifier: identifier }
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)["challenge"]
  end


  def list_landing_page_templates
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/landing_page_templates.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end

  def show_landing_page_template(id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/landing_page_templates/#{id}.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end

  def list_landing_pages
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/landing_pages.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end

  def create_landing_page(params)
    rapi_conn = get_connection

    json_response = rapi_conn.post do |req|
      req.url '/admin/landing_pages.json'
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  def update_landing_page(id, params)
    rapi_conn = get_connection

    json_response = rapi_conn.put do |req|
      req.url "/admin/landing_pages/#{id}.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  def show_landing_page(id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/landing_pages/#{id}.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end

  def show_promotion_group(id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/promotion_groups/#{id}.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)    
  end

  def list_promotion_groups
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/promotion_groups.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)    
  end

  def update_promotion_group(id, params)
    rapi_conn = get_connection

    json_response = rapi_conn.put do |req|
      req.url "/admin/promotion_groups/#{id}.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  def create_promotion_group(params)
    rapi_conn = get_connection

    json_response = rapi_conn.post do |req|
      req.url '/admin/promotion_groups.json'
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

private

  def admin_token
    ENV['ADMIN_TOKEN']
  end

  def get_connection
    url = if ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(ENV["LOCAL_TESTING_MODE"])
      ENV["URL_BASE_TEST"]
    else
      ENV["URL_BASE"]
    end

    Faraday.new(:url => "#{url}") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end
