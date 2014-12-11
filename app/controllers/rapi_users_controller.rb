class RapiUsersController < ApplicationController
  before_filter :require_user

  def search
    config = YAML.load(File.open("#{Rails.root}/config/rapi.yml"))
    environment = config[Rails.env]["environment"]

    oauth_token = OauthManager.execute(environment: environment, client_app: "dailymvp" || params[:client_app])
    rapi_response = RapiManager.new(environment: environment, oauth_token: oauth_token).user(params[:username])

    render json: rapi_response
  end

end
