class GamesController < ApplicationController
    before_action :authenticate_user!

    def new
        @profile = Profile.find(params[:profile_id])
        if @profile.user != current_user
          redirect_to root_path, alert: "You are not authorized to create a game for this profile."
        else
          @game = @profile.games.new
        end
    end
    
    def edit
        @game = Game.find(params[:id])
        @game.achievements ||= []
      end         
    
    def update
        @game = Game.find(params[:id])
        if @game.update(game_params)
          redirect_to profile_path(@game.profile), notice: "Game updated successfully!"
        else
          render :edit, status: :unprocessable_entity
        end
    end
  
    def create
        @profile = Profile.find(params[:profile_id])
        if @profile.user != current_user
          redirect_to root_path, alert: "You are not authorized to create a game for this profile."
        else
          @game = @profile.games.new(game_params)
          if @game.save
            redirect_to profile_path(@profile), notice: "Game was successfully created."
          else
            render :new, status: :unprocessable_entity
          end
        end
    end  
    
    def destroy
        @game = Game.find(params[:id])
        @game.destroy
        redirect_to profile_path(current_user.profile), notice: "Game was successfully deleted."
    end
      
    private
  
    def game_params
        params.require(:game).permit(:name, :rank, :main, :join_date, :is_wishlist, achievements: [])
    end
end
