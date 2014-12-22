class LandingPagesController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def index
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @landing_pages = RapiManager.new(oauth_token: oauth_token).list_landing_pages
  end

  def new
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @landing_page_templates = RapiManager.new(oauth_token: oauth_token).list_landing_page_templates
    @landing_page = LandingPageHashie.new
  end

  def edit
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @landing_page_templates = RapiManager.new(oauth_token: oauth_token).list_landing_page_templates

    landing_page_hash = RapiManager.new(oauth_token: oauth_token).show_landing_page(params[:id])
    landing_page_hash["template_variables"] = JSON.pretty_generate(landing_page_hash["template_variables"])
    @landing_page = LandingPageHashie.build_from_rapi_hash(landing_page_hash)
  end
  
  def update
    oauth_token = OauthManager.execute(client_app: @current_client_app)

    landing_page_params = {
      "landing_page" => {
        "name" => params[:name],
        "landing_page_template_id" => params[:landing_page_template_id],
        "template_variables" => params[:template_variables]
      }
    }
    if is_json?(params[:template_variables])

      update_response = RapiManager.new(oauth_token: oauth_token).update_landing_page(params[:id], landing_page_params.to_json)
      if update_response.status == 200
        flash.keep[:notice] = "Landing Page updated!"
        redirect_to landing_pages_path
      else
        @landing_page_templates = RapiManager.new(oauth_token: oauth_token).list_landing_page_templates
        @landing_page = LandingPageHashie.build_from_rapi_hash(landing_page_params["landing_page"])

        errors_hash = JSON.parse(update_response.body)
        errors_text = errors_hash.keys.collect { |key|
          "#{key.to_s} - #{errors_hash[key].join(";")}"
        }.join("\n")

        flash.now[:error] = errors_text
        render :edit
      end
    else
      @landing_page_templates = RapiManager.new(oauth_token: oauth_token).list_landing_page_templates
      @landing_page = LandingPageHashie.build_from_rapi_hash(landing_page_params["landing_page"])
      flash.now[:error] = "Variables must be valid JSON"
      render :new
    end
  end


  def create
    oauth_token = OauthManager.execute(client_app: @current_client_app)

    landing_page_params = {
      "landing_page" => {
        "name" => params[:name],
        "landing_page_template_id" => params[:landing_page_template_id],
        "template_variables" => params[:template_variables]
      }
    }
    if is_json?(params[:template_variables])

      create_response = RapiManager.new(oauth_token: oauth_token).create_landing_page(landing_page_params.to_json)
      if create_response.status == 200
        flash.keep[:notice] = "Landing Page created!"
        redirect_to landing_pages_path
      else
        @landing_page_templates = RapiManager.new(oauth_token: oauth_token).list_landing_page_templates
        @landing_page = LandingPageHashie.build_from_rapi_hash(landing_page_params["landing_page"])

        errors_hash = JSON.parse(create_response.body)
        errors_text = errors_hash.keys.collect { |key|
          "#{key.to_s} - #{errors_hash[key].join(";")}"
        }.join("\n")

        flash.now[:error] = errors_text
        render :new
      end
    else
      @landing_page_templates = RapiManager.new(oauth_token: oauth_token).list_landing_page_templates
      @landing_page = LandingPageHashie.build_from_rapi_hash(landing_page_params["landing_page"])
      flash.now[:error] = "Variables must be valid JSON"
      render :new
    end
  end

  private 
  
  def is_json?(something)
    begin
      !!JSON.parse(something)
    rescue
      false
    end
  end
end