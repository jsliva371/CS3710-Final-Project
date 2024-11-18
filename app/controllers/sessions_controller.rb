class SessionsController < ApplicationController
    def create
      steam_data = request.env['omniauth.auth']
      steam_id = steam_data['uid']
      steam_info = steam_data['info']
      
      # Find the currently logged-in user
      user = current_user
      
      if user
        # Ensure profile exists and update steam_id
        profile = user.profile
        if profile
          if profile.steam_id.nil?
            profile.update(steam_id: steam_id)
            redirect_to profile_path(profile), notice: 'Steam account successfully linked!'
          else
            redirect_to profile_path(profile), alert: 'Steam account already linked!'
          end
        else
          redirect_to root_path, alert: 'Profile not found!'
        end
      else
        # Handle case where the user is not logged in
        redirect_to new_user_session_path, alert: 'Please log in first to link your Steam account.'
      end
    end
  
    def failure
      redirect_to root_path, alert: "Steam login failed!"
    end
  
    def destroy
      # Reset the Steam session and redirect to the root
      reset_session
      redirect_to root_path, notice: "Logged out successfully."
    end
  end
  