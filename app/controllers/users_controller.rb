class UsersController < ApplicationController
  def search
    @user_results = RapiManager.new.search_users(params[:query])
  end

  def identity_lookup
    @user_uuid = params[:user_uuid]
    if @user_uuid.present?
      @identity_information = RapiManager.new.lookup_user_identity(@user_uuid)
    end
  end

  def search_csv
    send_data RapiManager.new.search_users_csv(params[:query]), type: Mime::CSV, disposition: "attachment; filename=users.csv"
  end

  def enable
    RapiManager.new.update_user(params[:id], { user: { state: "active" }}.to_json)
    redirect_to :back
  end

  def disable
    RapiManager.new.update_user(params[:id], { user: { state: "disabled" }}.to_json)
    redirect_to :back
  end
end
