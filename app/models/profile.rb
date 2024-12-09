class Profile < ApplicationRecord
  belongs_to :user
  has_many :games, dependent: :destroy

  # Friendships initiated by this profile
  has_many :friends, foreign_key: :profile_id, dependent: :destroy
  has_many :friend_profiles, through: :friends, source: :friend_profile

  # Friendships where this profile is added as a friend
  has_many :inverse_friends, class_name: 'Friend', foreign_key: :friend_profile_id, dependent: :destroy
  has_many :inverse_friend_profiles, through: :inverse_friends, source: :profile

  validates :username, presence: true

  # Convert platforms to an array when reading from the database
  def platforms
    super.to_s.split(',').map(&:strip)
  end

  # Convert array back to a string when saving to the database
  def platforms=(value)
    super(value.is_a?(Array) ? value.join(',') : value)
  end

  # Initialize wishlist if it's nil
  def wishlist
    self[:wishlist] || []
  end

  # Add a game to the wishlist
  def add_to_wishlist(appid)
    return if wishlist.any? { |g| g[:appid] == appid }  # Prevent duplicates

    # Fetch the game details from SteamSpyService
    steamspy = SteamSpyService.new
    game_details = steamspy.get_game_details(appid)

    # Only proceed if valid game details were fetched
    if game_details
      game = {
        appid: game_details["appid"],
        name: game_details["name"],
        developer: game_details["developer"],
        publisher: game_details["publisher"],
        players_2weeks: game_details["players_2weeks"],
        current_players: game_details["ccu"]
      }

      # Add the game details to the wishlist
      self.wishlist ||= [] 
      self.wishlist << game
      save
    end
  end

  # Remove a game from the wishlist by appid
  def remove_from_wishlist(appid)
    self.wishlist.reject! { |game| game["appid"] == appid }
    save
  end

  # Get the game details for all games in the wishlist
def wishlist_games
  # Log the start of the method call
  Rails.logger.debug "Calling wishlist_games method"
  
  return [] if wishlist.blank?

  steamspy = SteamSpyService.new
  games = wishlist.map { |appid| steamspy.get_game_details(appid) }.compact
  
  # Log the result of the method
  Rails.logger.debug "Wishlist games found: #{games.inspect}"
  
  games
end

  
end
