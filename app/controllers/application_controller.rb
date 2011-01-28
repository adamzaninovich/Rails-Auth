class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  helper_method :current_user, :logged_in?
  
  private
  
  def logged_in?
    session[:user_id].present?
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to view this page"
      redirect_to new_session_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default=root_url)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
