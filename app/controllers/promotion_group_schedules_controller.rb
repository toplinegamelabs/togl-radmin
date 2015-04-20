class PromotionGroupSchedulesController < ApplicationController
  before_filter :require_user

  require 'net/http'
  require 'uri'

  def index
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    @promotion_group_schedules = []
  end

  def create
  end

  def delete
  end
end
