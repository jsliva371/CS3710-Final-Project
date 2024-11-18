class SteamService
    def initialize(api_key, steam_id)
      @api_key = api_key
      @steam_id = steam_id
    end
  
    def fetch_recently_played_games
      Rails.logger.debug "Fetching recently played games for Steam ID: #{@steam_id}"
  
      uri = URI("http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key=#{@api_key}&steamid=#{@steam_id}&format=json")
      response = Net::HTTP.get(uri)
      parsed_response = JSON.parse(response)
  
      # Log the number of games fetched
      Rails.logger.debug "Fetched #{parsed_response['response']['games'].size} games."
  
      # Return the games array from the response
      parsed_response["response"]["games"]
      
    rescue StandardError => e
      Rails.logger.error "Error fetching games: #{e.message}"
      []
    end
end
  
  