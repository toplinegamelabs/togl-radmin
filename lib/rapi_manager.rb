class RapiManager
  def initialize(opts={})
  end


  def list_games
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end
  
  def list_contest_templates(game_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/games/#{game_id}/contest_templates.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end

  def list_event_sets(game_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/games/#{game_id}/event_sets.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end

  def list_open_contests(game_id, event_set_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games/#{game_id}/event_sets/#{event_set_id}/open_contests"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end

  def create_empty_contest(contest_template_id)
    rapi_conn = get_connection
    json_response = rapi_conn.post do |req|
      req.url "/admin/contest_templates/#{contest_template_id}/create_empty_contest"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
  end

  def list_event_participants_by_contest_template(game_id, contest_template_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games/#{game_id}/contest_templates/#{contest_template_id}/event_participants.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end

  def list_event_participants_by_event_set(game_id, event_set_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games/#{game_id}/event_sets/#{event_set_id}/event_participants.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end

  def show_user_by_username(username)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_lookup.json", { username: username }
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)
  end

  def search_users(query_string)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_search.json", { query: query_string }
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)["users"]
  end

  def lookup_user_identity(user_uuid)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_identity_lookup.json", { user_uuid: user_uuid }
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)["user_identity"]
  end

  def lookup_user_contests_by_username(username)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_contests_lookup.json", { username: username }
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)["contests"]
  end

  def lookup_user_contests_by_email(email)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_contests_lookup.json", { email: email }
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)["contests"]
  end

  def lookup_user_contests_by_uuid(uuid)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_contests_lookup.json", { user_uuid: uuid }
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    JSON.parse(json_response.body)["contests"]
  end

  def leave_user_contest(id)
    rapi_conn = get_connection
    json_response = rapi_conn.post do |req|
      req.url "/admin/user_contests/#{id}/leave"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    json_response.status
  end

  def search_users_csv(query_string)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_search.csv", { query: query_string }
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end
    json_response.body
  end

  def update_user(id, properties)
    rapi_conn = get_connection
    json_response = rapi_conn.patch do |req|
      req.url "/admin/users/#{id}.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = properties
    end
  end

  def create_promo(params)
    rapi_conn = get_connection
    json_response = rapi_conn.post do |req|
      req.url '/admin/promotions.json'
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  def update_promotion(params)
    rapi_conn = get_connection
    json_response = rapi_conn.put do |req|
      req.url '/admin/promotions.json'
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)["challenge"] || JSON.parse(json_response.body)["contest"]
  end

  def list_landing_page_templates
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/landing_page_templates.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
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
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  def create_promotion_group_schedule(promotion_group_id, params)
    rapi_conn = get_connection

    json_response = rapi_conn.post do |req|
      req.url "/admin/promotion_groups/#{promotion_group_id}/promotion_group_schedules.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  def put_promotion_group_schedule(promotion_group_id, id, params)
    rapi_conn = get_connection

    json_response = rapi_conn.put do |req|
      req.url "/admin/promotion_groups/#{promotion_group_id}/promotion_group_schedules/#{id}.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
      req.body = params
    end
  end

  def list_promotion_group_schedules(promotion_group_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/promotion_groups/#{promotion_group_id}/promotion_group_schedules.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)    
  end

  def destroy_promotion_group_schedule(promotion_group_id, id)
    rapi_conn = get_connection

    json_response = rapi_conn.delete do |req|
      req.url "/admin/promotion_groups/#{promotion_group_id}/promotion_group_schedules/#{id}.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)    
  end

  def show_promotion_group_schedule(promotion_group_id, id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/promotion_groups/#{promotion_group_id}/promotion_group_schedules/#{id}.json"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)    
  end

  def get_date_range_metrics(start_date, end_date)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/metrics/date_range_stats.json?start_date=#{start_date}&end_date=#{end_date}"
      req.headers['Authorization'] = 'Token token="' + auth_token + '"'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)    
  end


  private

  def auth_token
    ENV["AUTH_TOKEN"]
  end

  def admin_token
    ENV['ADMIN_TOKEN']
  end

  def get_connection
    if ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(ENV["LOCAL_TESTING_MODE"])
      url = ENV["URL_BASE_TEST"]
    else
      url = "#{ENV["URL_BASE"]}api.togl.io"
    end

    Faraday.new(:url => "#{url}") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      # faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end
