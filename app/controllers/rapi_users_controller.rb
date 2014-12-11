class RapiUsersController < ApplicationController
  before_filter :require_user

  def search
    oauth_token = OauthManager.execute(client_app: "dailymvp" || params[:client_app])
    rapi_response = RapiManager.new(oauth_token: oauth_token).user(params[:username])

    render json: rapi_response
  end

end
