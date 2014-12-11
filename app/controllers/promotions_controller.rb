class PromotionsController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'


  def index
    config = YAML.load(File.open("#{Rails.root}/config/rapi.yml"))
    environment = config[Rails.env]["environment"]

    oauth_token = OauthManager.execute(environment: environment, client_app: "dailymvp" || params[:client_app])
    @promotions = RapiManager.new(environment: environment, oauth_token: oauth_token).promotions
  end

  def new
    
    config = YAML.load(File.open("#{Rails.root}/config/rapi.yml"))
    environment = config[Rails.env]["environment"]

    oauth_token = OauthManager.execute(environment: environment, client_app: "dailymvp" || params[:client_app])
    rapi_response = RapiManager.new(environment: environment, oauth_token: oauth_token).games

    @games = [[]] + rapi_response["games"].collect do |game|
      [game["name"], game["id"]]
    end




    # config = YAML.load(File.open("#{Rails.root}/config/rapi.yml"))
    # base_url = config[Rails.env]["base_url"]

    # games_url = URI.parse(URI.join(base_url, "games.json").to_s)
    # games_request = Net::HTTP::Get.new(games_url.path)
    # games_request["X-Application-Bypass"] = "dailymvp"
    # games_result = Net::HTTP.new(games_url.host, games_url.port).start do |http|
    #   http.request(games_request)
    # end
    # @games = JSON.parse(games_result.body)["games"].select { |g| g["state"] == "active" }


    # @contest_templates = []
    # @games.each do |game|
    #   contest_templates_url = URI.parse(URI.join(base_url, "/games/#{game["id"]}/contest_templates.json").to_s)
    #   contest_templates_request = Net::HTTP::Get.new(contest_templates_url.path)
    #   contest_templates_request["X-Application-Bypass"] = "dailymvp"
    #   contest_templates_result = Net::HTTP.new(contest_templates_url.host, contest_templates_url.port).start do |http|
    #     http.request(contest_templates_request)
    #   end

    #   ct_result_json = JSON.parse(contest_templates_result.body)
    #   ct_result_json["event_sets"].each do |event_set|

    #     event_set["contest_templates"].each do |contest_template|
    #       @contest_templates << ["#{event_set["description"]} - #{contest_template["buy_in"]["label"]} - #{contest_template["size"]["label"]}", contest_template["id"]]
    #     end

    #   end
    #   #JSON.parse(contest_templates_result.body)["contest_templates"].select { |g| g["state"] == "active" }
    # end
  end

  def edit
    
  end

  def create
    config = YAML.load(File.open("#{Rails.root}/config/rapi.yml"))
    environment = config[Rails.env]["environment"]

    oauth_token = OauthManager.execute(environment: environment, client_app: "dailymvp" || params[:client_app])
    
    #user_response = RapiManager.new(environment: environment, oauth_token: oauth_token).user(params["username"])

    
    entry_hash = { entry_items: [] }
    params["entry_item"].each_with_index do |entry_item, index|
      entry_hash[:entry_items] << {
        event_participant_id: entry_item.to_i,
        slot_id: index + 1
      }
    end

    post_params = {
      user_id: params["user_id"],
      contest_template_id: params[:contest_template_id],
      max: params[:max],
      entry: entry_hash,
      promotion: {
        name: params["promo_name"],
        identifier: params["promo_identifier"],
        description: params["promo_description"],
        images: {
            mobile: {
              banner: params["promo_mobile_banner"],
              background: params["promo_mobile_background"],
              badge: params["promo_mobile_badge"]
            },
            desktop: {
              banner: params["promo_desktop_banner"],
              background: params["promo_desktop_background"],
              badge: params["promo_desktop_badge"]
            },
            tablet: {
              banner: params["promo_tablet_banner"],
              background: params["promo_tablet_background"],
              badge: params["promo_tablet_badge"]
            }
          },
        name_logo: {
            unicode: params["promo_logo_unicode"],
            css_class: params["promo_logo_css_class"]
          },
        display_type: params["promo_display_type"]
      }
    }
    create_response = RapiManager.new(environment: environment, oauth_token: oauth_token).create_promo_challenge(post_params.to_json)

    if create_response.status == 201
      flash.keep[:notice] = "Promotion created!"
      redirect_to promotions_path
    else
      flash.keep[:error] = JSON.parse(create_response.body).values.flatten.join("\n")
      redirect_to :back
    end
  end



  def identifier_check
    config = YAML.load(File.open("#{Rails.root}/config/rapi.yml"))
    environment = config[Rails.env]["environment"]

    oauth_token = OauthManager.execute(environment: environment, client_app: "dailymvp" || params[:client_app])
    rapi_response = RapiManager.new(environment: environment, oauth_token: oauth_token).promotions

    exists = rapi_response.select { |promo_contest| promo_contest["promotion"]["identifier"].to_s.downcase == params[:identifier].to_s.downcase }.present?

    render json: { exists: exists }
  end
end
