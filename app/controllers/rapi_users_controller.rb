class RapiUsersController < ApplicationController
  before_filter :require_user

  def search
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    rapi_response = RapiManager.new(oauth_token: oauth_token).user_by_username(params[:username])

    rapi_response["balance"] = rapi_response["balance"]

    render json: rapi_response
  end

end
