class PromotionGroupsController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def index
    @promotion_groups = RapiManager.new.list_promotion_groups
  end

  def list_for_schedules
    @promotion_groups = RapiManager.new.list_promotion_groups
  end

  def edit
    @landing_pages = RapiManager.new.list_landing_pages
    
    pg_hash = RapiManager.new.show_promotion_group(params[:id])
    @promo_group = PromotionGroupHashie.build_from_rapi_hash(pg_hash)
    @promo_group.persisted = true
  end

  def new
    @landing_pages = RapiManager.new.list_landing_pages
    @promo_group = PromotionGroupHashie.new
  end

  def update
    Time.zone = "America/Los_Angeles"



    promotion_group_params = {
      "promotion_group" => {
        "identifier" => params[:identifier],
        "landing_page_id" => params[:landing_page_id],
        "ends_at" => params[:ends_at].present? ? Time.zone.parse(params[:ends_at] + " 11:59PM") : ""
      }
    }

    update_response = RapiManager.new.update_promotion_group(params[:id], promotion_group_params.to_json)
    if update_response.status == 200
      flash.keep[:notice] = "Promotion group updated!"
      redirect_to promotion_groups_path
    else
      @landing_pages = RapiManager.new.list_landing_pages
      @promo_group = PromotionGroupHashie.build_from_rapi_hash(promotion_group_params["promotion_group"])

      errors_hash = JSON.parse(update_response.body)
      errors_text = errors_hash.keys.collect { |key|
        "#{key.to_s} - #{errors_hash[key].join(";")}"
      }.join("\n")

      flash.now[:error] = errors_text
      render :new
    end
  end

  def create
    
    Time.zone = "America/Los_Angeles"

    promotion_group_params = {
      "promotion_group" => {
        "identifier" => params[:identifier],
        "landing_page_id" => params[:landing_page_id],
        "ends_at" => Time.zone.parse(params[:ends_at]),
        "user_group" => params[:user_group] == 'true'
      }
    }

    create_response = RapiManager.new.create_promotion_group(promotion_group_params.to_json)
    if create_response.status == 200
      flash.keep[:notice] = "Promotion group created!"
      redirect_to promotion_groups_path
    else
      @landing_pages = RapiManager.new.list_landing_pages
      @promo_group = PromotionGroupHashie.build_from_rapi_hash(promotion_group_params["promotion_group"])

      errors_hash = JSON.parse(create_response.body)
      errors_text = errors_hash.keys.collect { |key|
        "#{key.to_s} - #{errors_hash[key]}"
      }.join("\n")

      flash.now[:error] = errors_text
      render :new
    end
  
  end
end
