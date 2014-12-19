class PromotionGroupsController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def index
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @promotion_groups = RapiManager.new(oauth_token: oauth_token).list_promotion_groups
  end

  def edit
  end

  def new

    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @landing_pages = RapiManager.new(oauth_token: oauth_token).landing_pages
    @promo_group = PromotionGroupHashie.new
  end

  def update
  end

  def create
    oauth_token = OauthManager.execute(client_app: @current_client_app)

    promotion_group_params = {
      "promotion_group" => {
        "identifier" => params[:identifier],
        "landing_page_id" => params[:landing_page_id]
      }
    }

    create_response = RapiManager.new(oauth_token: oauth_token).create_promotion_group(promotion_group_params.to_json)
    if create_response.status == 200
      flash.keep[:notice] = "Promotion group created!"
      redirect_to promotion_groups_path
    else
      @landing_pages = RapiManager.new(oauth_token: oauth_token).landing_pages
      @promo_group = PromotionGroupHashie.build_from_rapi_hash(promotion_group_params["promotion_group"])

      errors_hash = JSON.parse(create_response.body)
      errors_text = errors_hash.keys.collect { |key|
        "#{key.to_s} - #{errors_hash[key].join(";")}"
      }.join("\n")

      flash.now[:error] = errors_text
      render :new
    end
  
  end
end
