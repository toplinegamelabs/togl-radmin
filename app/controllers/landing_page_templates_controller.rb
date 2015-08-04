class LandingPageTemplatesController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def show

    @landing_page_template = RapiManager.new.show_landing_page_template(params[:id])

    render json: @landing_page_template
  end
end