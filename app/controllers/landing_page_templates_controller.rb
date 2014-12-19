class LandingPageTemplatesController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def show
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @landing_page_template = RapiManager.new(oauth_token: oauth_token).show_landing_page_template(params[:id])

    render json: @landing_page_template
  end
end