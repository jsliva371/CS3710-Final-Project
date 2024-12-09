class HomeController < ApplicationController
  def index
    steam_spy_service = SteamSpyService.new
    games = steam_spy_service.get_top_100_games_in_2weeks

    # Select the top 10 games based on current concurrent users
    @top_games = games[0..9]
    @profile = current_user&.profile # Cache the profile for easier access in the view
  rescue StandardError => e
    Rails.logger.error "Error fetching top games: #{e.message}"
    @top_games = [] # Default to an empty array in case of an error
  end
end
