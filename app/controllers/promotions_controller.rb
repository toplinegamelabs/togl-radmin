class PromotionsController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def index
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @promotions = RapiManager.new(oauth_token: oauth_token).list_promotions["promotions"].select { |p| p.present? }
  end

  def new
    if params[:id]

      oauth_token = OauthManager.execute(client_app: @current_client_app)
      promo_contest = RapiManager.new(oauth_token: oauth_token).show_promotion_by_identifier(params[:id])
      user = RapiManager.new(oauth_token: oauth_token).show_user_by_id(promo_contest["creator_id"])
      promo_contest["username"] = user["username"]

      @promotion_target = PromotionTargetHashie.build_from_rapi_hash(promo_contest)
      @promotion_target.persisted = true

      original_contest_template = @challenge.contest_template
      @promotion_target.contest_template = ContestTemplateHashie.new
      @promotion_target.contest_template.game = original_contest_template.game
      @promotion_target.entry = EntryHashie.new
    else
      @promotion_target = PromotionTargetHashie.new
    end

    oauth_token = OauthManager.execute(client_app: @current_client_app)
    rapi_response = RapiManager.new(oauth_token: oauth_token).list_games

    @games = [[]] + rapi_response["games"].collect do |game|
      [game["name"], game["id"]]
    end

    @promotion_groups = [[]] + RapiManager.new(oauth_token: oauth_token).list_promotion_groups.collect do |group|
      [group["identifier"], group["id"]]
    end
  end

  def edit
    @allow_client_app_selector = false
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    promo_contest = RapiManager.new(oauth_token: oauth_token).show_promotion_by_identifier(params[:id])
    user = RapiManager.new(oauth_token: oauth_token).show_user_by_id(promo_contest["creator_id"])
    promo_contest["username"] = user["username"]

    @promotion_target = PromotionTargetHashie.build_from_rapi_hash(promo_contest)
    @promotion_target.persisted = true

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
      "user_id" => params["user_id"],
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
        "emails" => {
            "contest_joined" => {
              "layout" => params["email_contest_joined_layout"],
              "subject" => params["email_contest_joined_subject"],
              "header" => {
                "image_url" => params["email_contest_joined_header_image_url"],
                "target_url" => params["email_contest_joined_header_target_url"],
                "color_code" => params["email_contest_joined_header_color_code"]
              },
              "body" => params["email_contest_joined_body"]
            },
            "contest_win" => {
              "layout" => params["email_contest_win_layout"],
              "subject" => params["email_contest_win_subject"],
              "header" => {
                "image_url" => params["email_contest_win_header_image_url"],
                "target_url" => params["email_contest_win_header_target_url"],
                "color_code" => params["email_contest_win_header_color_code"]
              },
              "body" => {
                "pre" => params["email_contest_win_body_pre"],
                "post" => params["email_contest_win_body_post"]
              }
            },
            "contest_loss" => {
              "layout" => params["email_contest_loss_layout"],
              "subject" => params["email_contest_loss_subject"],
              "header" => {
                "image_url" => params["email_contest_loss_header_image_url"],
                "target_url" => params["email_contest_loss_header_target_url"],
                "color_code" => params["email_contest_loss_header_color_code"]
              },
              "body" => {
                "pre" => params["email_contest_loss_body_pre"],
                "post" => params["email_contest_loss_body_post"]
              }
            },
            "contest_tie" => {
              "layout" => params["email_contest_tie_layout"],
              "subject" => params["email_contest_tie_subject"],
              "header" => {
                "image_url" => params["email_contest_tie_header_image_url"],
                "target_url" => params["email_contest_tie_header_target_url"],
                "color_code" => params["email_contest_tie_header_color_code"]
              },
              "body" => {
                "pre" => params["email_contest_tie_body_pre"],
                "post" => params["email_contest_tie_body_post"]
              }
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
      promo_contest = RapiManager.new(oauth_token: oauth_token).show_promotion_by_identifier(params["promo_identifier"])
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
      "contest_template_settings" => {
        "game_id"               => params["game_id"],
        "buy_in"                => params["buy_in"],
        "size"                  => params["size"],
        "is_publicly_joinable"  => params["is_publicly_joinable"] == "picked",
        "event_set_id"          => params["event_set_id"],
        "rewards"               => [
          {
            "start_place" => 1,
            "end_place" => 1,
            "item" => {
              "type" => "balance",
              "value" => 1500
            }
          }
        ]
      },
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
        "display_type" => params["promo_display_type"],
        "emails" => {
          "contest_joined" => {
            "layout" => params["email_contest_joined_layout"],
            "subject" => params["email_contest_joined_subject"],
            "header" => {
              "image_url" => params["email_contest_joined_header_image_url"],
              "target_url" => params["email_contest_joined_header_target_url"],
              "color_code" => params["email_contest_joined_header_color_code"]
            },
            "body" => params["email_contest_joined_body"]
          },
          "contest_win" => {
            "layout" => params["email_contest_win_layout"],
            "subject" => params["email_contest_win_subject"],
            "header" => {
              "image_url" => params["email_contest_win_header_image_url"],
              "target_url" => params["email_contest_win_header_target_url"],
              "color_code" => params["email_contest_win_header_color_code"]
            },
            "body" => {
              "pre" => params["email_contest_win_body_pre"],
              "post" => params["email_contest_win_body_post"]
            }
          },
          "contest_loss" => {
            "layout" => params["email_contest_loss_layout"],
            "subject" => params["email_contest_loss_subject"],
            "header" => {
              "image_url" => params["email_contest_loss_header_image_url"],
              "target_url" => params["email_contest_loss_header_target_url"],
              "color_code" => params["email_contest_loss_header_color_code"]
            },
            "body" => {
              "pre" => params["email_contest_loss_body_pre"],
              "post" => params["email_contest_loss_body_post"]
            }
          },
          "contest_tie" => {
            "layout" => params["email_contest_tie_layout"],
            "subject" => params["email_contest_tie_subject"],
            "header" => {
              "image_url" => params["email_contest_tie_header_image_url"],
              "target_url" => params["email_contest_tie_header_target_url"],
              "color_code" => params["email_contest_tie_header_color_code"]
            },
            "body" => {
              "pre" => params["email_contest_tie_body_pre"],
              "post" => params["email_contest_tie_body_post"]
            }
          }
        }
      }
    }
    create_response = RapiManager.new(oauth_token: oauth_token).create_promo(post_params.to_json)

    if create_response.status == 201
      flash.keep[:notice] = "Promotion created!"
      redirect_to promotions_path
    else
      rapi_response = RapiManager.new(oauth_token: oauth_token).list_games
      @games = [[]] + rapi_response["games"].collect do |game|
        [game["name"], game["id"]]
      end

      @promotion_groups = [[]] + RapiManager.new(oauth_token: oauth_token).list_promotion_groups.collect do |group|
        [group["identifier"], group["id"]]
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
      
      @promotion_target = PromotionTargetHashie.build_from_rapi_hash(promo_contest)



      flash.now[:error] = JSON.parse(create_response.body).values.flatten.join("\n")
      render :new
    end
  end



  def identifier_check
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    rapi_response = RapiManager.new(oauth_token: oauth_token).list_promotions.select { |p| p.present? }

    exists = rapi_response.select { |promo_contest| promo_contest["promotion"]["identifier"].to_s.downcase == params[:identifier].to_s.downcase }.present?

    render json: { exists: exists }
  end
end
