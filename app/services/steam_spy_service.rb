class SteamSpyService
    def get_top_100_games_in_2weeks
      url = URI("https://steamspy.com/api.php?request=top100in2weeks")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
  
      # Sort by "ccu" (current concurrent users) in descending order
      data.values.sort_by { |game| -game["ccu"].to_i }
    rescue StandardError => e
      Rails.logger.error "Error fetching data from SteamSpy API: #{e.message}"
      [] # Return an empty array in case of an error
    end
  end
  
  