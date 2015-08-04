class RapiUsersController < ApplicationController
  before_filter :require_user

  def search
    rapi_response = RapiManager.new.show_user_by_username(params[:username])

    rapi_response["balance"] = rapi_response["balance"]

    render json: rapi_response
  end

  def csv_list
    rapi_response = RapiManager.new.user_csv_list



    send_data rapi_response.join("\n"), filename: "users.csv"
  end

end
