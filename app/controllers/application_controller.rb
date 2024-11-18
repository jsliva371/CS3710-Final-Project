class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_steam_user_from_session, if: :steam_logged_in?
  
    protected
  
    # Configure Devise parameters for sign up and account updates
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
      devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname])
    end
  
    # Check if the user is logged in through Steam
    def steam_logged_in?
      session[:steam_id].present?
    end
  
    # Set the Steam user details from the session
    def set_steam_user_from_session
      @steam_user = { steam_id: session[:steam_id], username: session[:username] }
    end
  
    # Optional helper to check if the user is logged in via Steam
    def current_steam_user
      @steam_user
    end
  end
  