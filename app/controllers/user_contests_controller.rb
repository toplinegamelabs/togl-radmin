class UserContestsController < ApplicationController
  def leave
    @result = RapiManager.new.leave_user_contest(params[:id])
  end
end
