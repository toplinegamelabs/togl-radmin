class PromotionsController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'


  def index
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @promotions = RapiManager.new(oauth_token: oauth_token).promotions.select { |p| p.present? }
  end

  def new
    if params[:id]

      oauth_token = OauthManager.execute(client_app: @current_client_app)
      promo_contest = RapiManager.new(oauth_token: oauth_token).promotion(params[:id])
      user = RapiManager.new(oauth_token: oauth_token).user_by_id(promo_contest["creator_id"])
      promo_contest["username"] = user["username"]
      @challenge = ChallengeHashie.build_from_rapi_hash(promo_contest)

      original_contest_template = @challenge.contest_template
      @challenge.contest_template = ContestTemplateHashie.new
      @challenge.contest_template.game = original_contest_template.game
      @challenge.entry = EntryHashie.new
    else
      @challenge = ChallengeHashie.new
    end

    oauth_token = OauthManager.execute(client_app: @current_client_app)
    rapi_response = RapiManager.new(oauth_token: oauth_token).games

    @games = [[]] + rapi_response["games"].collect do |game|
      [game["name"], game["id"]]
    end

    @promotion_groups = [[]] + RapiManager.new(oauth_token: oauth_token).list_promotion_groups.collect do |group|
      [group["identifier"], group["id"]]
    end
  end

  def edit

    oauth_token = OauthManager.execute(client_app: @current_client_app)
    promo_contest = RapiManager.new(oauth_token: oauth_token).promotion(params[:id])
    user = RapiManager.new(oauth_token: oauth_token).user_by_id(promo_contest["creator_id"])
    promo_contest["username"] = user["username"]

    @challenge = ChallengeHashie.build_from_rapi_hash(promo_contest)
    @challenge.persisted = true

    @promotion_groups = [[]] + RapiManager.new(oauth_token: oauth_token).list_promotion_groups.collect do |group|
      [group["identifier"], group["id"]]
    end
  end

  def update_by_identifier
    oauth_token = OauthManager.execute(client_app: @current_client_app)
  
    entry_hash = { "id" => params[:entry_id], "entry_items" => [] }
    params["entry_item"].each_with_index do |entry_item, index|
      entry_hash["entry_items"] << {
        "event_participant_id" => entry_item.to_i,
        "event_participant" => {
          "id" => entry_item.to_i
        },
        "slot_id" => index + 1
      }
    end

    put_params = {
      "contest_template_id" => params["contest_template_id"],
      "entry" => entry_hash,
      "max" => params["max"],
      "promotion" => {
        "name" => params["promo_name"],
        "identifier" => params["promo_identifier"],
        "description" => params["promo_description"],
        "promotion_group_id" => params["promotion_group_id"],
        "images" => {
            "mobile" => {
              "banner" => params["promo_mobile_banner"],
              "background" => params["promo_mobile_background"],
              "badge" => params["promo_mobile_badge"]
            },
            "desktop" => {
              "banner" => params["promo_desktop_banner"],
              "background" => params["promo_desktop_background"],
              "badge" => params["promo_desktop_badge"]
            },
            "tablet" => {
              "banner" => params["promo_tablet_banner"],
              "background" => params["promo_tablet_background"],
              "badge" => params["promo_tablet_badge"]
            }
          },
        "name_logo" => {
            "unicode" => params["promo_logo_unicode"],
            "css_class" => params["promo_logo_css_class"]
          },
        "display_type" => params["promo_display_type"]
      }
    }
    update_response = RapiManager.new(oauth_token: oauth_token).update_promo_challenge(put_params.to_json)

    if update_response.status == 204
      flash.keep[:notice] = "Promotion updated!"
      redirect_to promotions_path
    else
      promo_contest = RapiManager.new(oauth_token: oauth_token).promotion(params["promo_identifier"])
      promo_contest["username"] = params[:username]
      put_params["promotion"]["description"] = put_params["promotion"]["description"].split("\r\n")
      promo_contest["promotion"].merge!(put_params["promotion"])
      promo_contest["max"] = params["max"]
      promo_contest["entry"] = entry_hash
      @challenge = ChallengeHashie.build_from_rapi_hash(promo_contest)
      @challenge.persisted = true
    
      flash.now[:error] = JSON.parse(update_response.body).values.flatten.join("\n")
      render :edit
    end
  end

  def create

    oauth_token = OauthManager.execute(client_app: @current_client_app)
    
    #user_response = RapiManager.new(oauth_token: oauth_token).user(params["username"])

    
    entry_hash = { "entry_items" => [] }
    params["entry_item"].each_with_index do |entry_item, index|
      entry_hash["entry_items"] << {
        "event_participant_id" => entry_item.to_i,
        "event_participant" => {
          "id" => entry_item.to_i
        },
        "slot_id" => index + 1
      }
    end

    post_params = {
      "user_id" => params["user_id"],
      "contest_template_id" => params[:contest_template_id],
      "max" => params[:max],
      "entry" => entry_hash,
      "promotion" => {
        "name" => params["promo_name"],
        "identifier" => params["promo_identifier"],
        "description" => params["promo_description"],
        "promotion_group_id" => params["promotion_group_id"],
        "images" => {
            "mobile" => {
              "banner" => params["promo_mobile_banner"],
              "background" => params["promo_mobile_background"],
              "badge" => params["promo_mobile_badge"]
            },
            "desktop" => {
              "banner" => params["promo_desktop_banner"],
              "background" => params["promo_desktop_background"],
              "badge" => params["promo_desktop_badge"]
            },
            "tablet" => {
              "banner" => params["promo_tablet_banner"],
              "background" => params["promo_tablet_background"],
              "badge" => params["promo_tablet_badge"]
            }
          },
        "name_logo" => {
            "unicode" => params["promo_logo_unicode"],
            "css_class" => params["promo_logo_css_class"]
          },
        "display_type" => params["promo_display_type"]
      }
    }
    create_response = RapiManager.new(oauth_token: oauth_token).create_promo_challenge(post_params.to_json)

    if create_response.status == 201
      flash.keep[:notice] = "Promotion created!"
      redirect_to promotions_path
    else
      rapi_response = RapiManager.new(oauth_token: oauth_token).games
      @games = [[]] + rapi_response["games"].collect do |game|
        [game["name"], game["id"]]
      end




      promo_contest = {
        "persisted" => false,
        "promotion" => { },
        "contest_template" => { "id" => params[:contest_template_id] },
        "event_set" => { },
        "game" => {
          "id" => params[:game_id]
        }
      }
      promo_contest["username"] = params[:username]
      post_params["promotion"]["description"] = post_params["promotion"]["description"].split("\r\n")
      promo_contest["promotion"].merge!(post_params["promotion"])
      promo_contest["max"] = params["max"]
      promo_contest["entry"] = entry_hash
      
      @challenge = ChallengeHashie.build_from_rapi_hash(promo_contest)



      flash.now[:error] = JSON.parse(create_response.body).values.flatten.join("\n")
      render :new
    end
  end



  def identifier_check

    oauth_token = OauthManager.execute(client_app: @current_client_app)
    rapi_response = RapiManager.new(oauth_token: oauth_token).promotions.select { |p| p.present? }

    exists = rapi_response.select { |promo_contest| promo_contest["promotion"]["identifier"].to_s.downcase == params[:identifier].to_s.downcase }.present?

    render json: { exists: exists }
  end
end
