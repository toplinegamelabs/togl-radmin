class UserContestsController < ApplicationController
  def leave
    @status = RapiManager.new.leave_user_contest(params[:id])
  end
end
