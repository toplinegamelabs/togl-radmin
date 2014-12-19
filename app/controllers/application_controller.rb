class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_filter :current_client_app
  before_filter :require_user, only: [:update_client_app]
  
  def require_user
    unless current_user
      flash[:notice] = "Log in first."
      redirect_to new_user_session_url
    end
  end

  def current_client_app
    @current_client_app = session[:client_app] || "dailymvp"
  end

  def update_client_app
    session[:client_app] = params[:client_app]
    render json: { client_app: session[:client_app] }
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end
