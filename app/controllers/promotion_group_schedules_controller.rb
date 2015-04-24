class PromotionGroupSchedulesController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def index
    Time.zone = "America/Los_Angeles"
    @promotion_group_id = params[:promotion_group_id]
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @promotion_group_schedules = RapiManager.new(oauth_token: oauth_token).list_promotion_group_schedules(@promotion_group_id).collect do |s|
      PromotionGroupScheduleHashie.build_from_rapi_hash(s)
    end
  end

  def edit

    Time.zone = "America/Los_Angeles"
    @promotion_group_id = params[:promotion_group_id]
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @schedule = PromotionGroupScheduleHashie.build_from_rapi_hash(RapiManager.new(oauth_token: oauth_token).show_promotion_group_schedule(@promotion_group_id, params[:id]))
  end

  def create
    Time.zone = "America/Los_Angeles"
    @promotion_group_id = params[:promotion_group_id]
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    
    schedule_params = {
      "promotion_group_schedule" => {
        "promotion_group_id" => @promotion_group_id,
        "league" => params[:league],
        "starts_at" => Time.zone.parse(params[:starts_at_date] + " " + params[:starts_at_time]),
        "starts_at_date_tbd" => params[:date_tbd].present?,
        "starts_at_time_tbd" => params[:time_tbd].present?
      }
    }

    create_response = RapiManager.new(oauth_token: oauth_token).create_promotion_group_schedule(@promotion_group_id, schedule_params.to_json)

    if create_response.status == 200
      flash.keep[:notice] = "Schedule created!"
    else
      errors_hash = JSON.parse(create_response.body)
      errors_text = errors_hash.keys.collect { |key|
        "#{key.to_s} - #{errors_hash[key].join(";")}"
      }.join("\n")

      flash.now[:error] = errors_text
    end

    @promotion_group_schedules = RapiManager.new(oauth_token: oauth_token).list_promotion_group_schedules(@promotion_group_id).collect do |s|
      PromotionGroupScheduleHashie.build_from_rapi_hash(s)
    end
    render :index

  end
  
  def update
    Time.zone = "America/Los_Angeles"
    @promotion_group_id = params[:promotion_group_id]
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    
    schedule_params = {
      "promotion_group_schedule" => {
        "promotion_group_id" => @promotion_group_id,
        "league" => params[:league],
        "starts_at" => Time.zone.parse(params[:starts_at_date] + " " + params[:starts_at_time]),
        "opens_at" => Time.zone.parse(params[:opens_at_date] + " " + params[:opens_at_time]),
        "starts_at_date_tbd" => params[:date_tbd].present?,
        "starts_at_time_tbd" => params[:time_tbd].present?
      }
    }

    put_response = RapiManager.new(oauth_token: oauth_token).put_promotion_group_schedule(@promotion_group_id, params[:id], schedule_params.to_json)

    if put_response.status == 200
      flash.keep[:notice] = "Schedule updated!"
    else
      errors_hash = JSON.parse(put_response.body)
      errors_text = errors_hash.keys.collect { |key|
        "#{key.to_s} - #{errors_hash[key].join(";")}"
      }.join("\n")

      flash.now[:error] = errors_text
    end

    @promotion_group_schedules = RapiManager.new(oauth_token: oauth_token).list_promotion_group_schedules(@promotion_group_id).collect do |s|
      PromotionGroupScheduleHashie.build_from_rapi_hash(s)
    end
    redirect_to promotion_group_promotion_group_schedules_path(promotion_group_id: params[:promotion_group_id])
  end

  def destroy
    @promotion_group_id = params[:promotion_group_id]
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    RapiManager.new(oauth_token: oauth_token).destroy_promotion_group_schedule(@promotion_group_id, params[:id])
    flash.keep[:notice] = "Schedule deleted"
    redirect_to :back    
  end
end
