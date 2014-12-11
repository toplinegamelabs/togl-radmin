class RapiManager
  def initialize(opts={})
    @oauth_token = opts.fetch(:oauth_token) { raise 'oauth token required' }
  end


  def games
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end
  
  def contest_templates(game_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games/#{game_id}/contest_templates.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end

  
  def event_participants(game_id, contest_template_id)
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/games/#{game_id}/contest_templates/#{contest_template_id}/event_participants.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(json_response.body)
  end

  def user(username)
    rapi_conn = get_connection
    json_response = rapi_conn.get do |req|
      req.url "/admin/user_lookup.json?username=#{username}"
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


  def promotions
    rapi_conn = get_connection

    json_response = rapi_conn.get do |req|
      req.url "/admin/promotions.json"
      req.headers['Authorization'] = 'Bearer ' + @oauth_token
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['ADMIN-TOKEN'] = admin_token
    end

    JSON.parse(json_response.body)
  end



private

  def admin_token
    ENV['ADMIN_TOKEN']
  end

  def get_connection
    Faraday.new(:url => "#{ENV["URL_BASE"]}api.togl.io") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  # def user_list(email)
  #   rapi_conn = Faraday.new(:url => "#{@rapi_protocol_base}-api.togl.io") do |faraday|
  #     faraday.request  :url_encoded             # form-encode POST params
  #     faraday.response :logger                  # log requests to STDOUT
  #     faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  #   end

  #   json_response = rapi_conn.get do |req|
  #     req.url "/bots/user_list.json?email=#{email}&client_app=dailymvp"
  #     req.headers['Authorization'] = 'Bearer ' + @oauth_token
  #     req.headers['Content-Type'] = 'application/json'
  #     req.headers['Accept'] = 'application/json'
  #     req.headers['BOT-TOKEN'] = '7bBY5j2JTs1W6'
  #   end

  #   JSON.parse(json_response.body)
  # end
  
  # def get(route)
  #   rapi_conn = Faraday.new(:url => "#{@rapi_protocol_base}-api.togl.io") do |faraday|
  #     faraday.request  :url_encoded             # form-encode POST params
  #     faraday.response :logger                  # log requests to STDOUT
  #     faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  #   end

  #   json_response = rapi_conn.get do |req|
  #     req.url "/bots/#{route}.json"
  #     req.headers['Authorization'] = 'Bearer ' + @oauth_token
  #     req.headers['Content-Type'] = 'application/json'
  #     req.headers['Accept'] = 'application/json'
  #     req.headers['BOT-TOKEN'] = '7bBY5j2JTs1W6'
  #   end

  #   JSON.parse(json_response.body)
  # end

  # def player_pool(date_string=nil)
  #   rapi_conn = Faraday.new(:url => "#{@rapi_protocol_base}-api.togl.io") do |faraday|
  #     faraday.request  :url_encoded             # form-encode POST params
  #     faraday.response :logger                  # log requests to STDOUT
  #     faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  #   end
    
  #   games_json_response = rapi_conn.get do |req|
  #     req.url "/games.json"
  #     req.headers['Authorization'] = 'Bearer ' + @oauth_token
  #     req.headers['Content-Type'] = 'application/json'
  #     req.headers['Accept'] = 'application/json'
  #     req.headers['BOT-TOKEN'] = '7bBY5j2JTs1W6'
  #   end

  #   games = JSON.parse(games_json_response.body)
  #   tripleplay = games["games"][1]

  #   contest_templates_json_response = rapi_conn.get do |req|
  #     req.url "/games/3/contest_templates.json"
  #     req.headers['Authorization'] = 'Bearer ' + @oauth_token
  #     req.headers['Content-Type'] = 'application/json'
  #     req.headers['Accept'] = 'application/json'
  #     req.headers['BOT-TOKEN'] = '7bBY5j2JTs1W6'
  #   end

  #   contest_templates = JSON.parse(contest_templates_json_response.body)

  #   if date_string
  #     contest_template_id_json_response = rapi_conn.get do |req|
  #       req.url "/bots/contest_template_id/#{date_string}.json"
  #       req.headers['Authorization'] = 'Bearer ' + @oauth_token
  #       req.headers['Content-Type'] = 'application/json'
  #       req.headers['Accept'] = 'application/json'
  #       req.headers['BOT-TOKEN'] = '7bBY5j2JTs1W6'
  #     end

  #     ct_id = JSON.parse(contest_template_id_json_response.body)["id"]
  #   else
  #     ct_id = contest_templates["event_sets"].first["contest_templates"].first["id"]
  #   end

  #   event_participants_json_response = rapi_conn.get do |req|
  #     req.url "/games/3/contest_templates/#{ct_id}/event_participants.json"
  #     req.headers['Authorization'] = 'Bearer ' + @oauth_token
  #     req.headers['Content-Type'] = 'application/json'
  #     req.headers['Accept'] = 'application/json'
  #     req.headers['BOT-TOKEN'] = '7bBY5j2JTs1W6'
  #   end

  #   event_participants = JSON.parse(event_participants_json_response.body)

  #   players = {
  #     pitchers: [],
  #     infielders: [],
  #     outfielders: []
  #   }
    
  #   event_participants["event_participants"].each do |event_participant|
  #     # puts "*** #{event_participant.inspect}"
  #     team = event_participant["player"]["team"]["abrv_name"]
  #     last_name = event_participant["player"]["last_name"]
      
  #     # add to players hash by team
  #     if players[team]
  #       players[team] = players[team] << last_name
  #     else
  #       players[team] = [last_name]
  #     end
      
  #     if event_participant["slot_groups"].include?("P")
  #       players[:pitchers] = players[:pitchers] << last_name
  #     # elsif event_participant["slot_groups"].include?("IF")
  #     #   players[:infielders] << event_participant["player"]["last_name"]
  #     # elsif event_participant["slot_groups"].include?("OF")
  #     #   players[:outfielders] << event_participant["player"]["last_name"]
  #     end
  #   end

  #   players
  # end
  
end
