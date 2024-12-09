class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy add_friend wishlist add_to_wishlist remove_from_wishlist]
  before_action :authenticate_user!

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    steam_service = SteamService.new("4C12A9733AD456CBF59B59B7A46F5BAB", @profile.steam_id)

    if @profile.steam_id.present?
      Rails.logger.debug "Calling fetch_recently_played_games for Steam ID: #{@profile.steam_id}" 
      @recent_games = steam_service.fetch_recently_played_games
      Rails.logger.debug "Recent games: #{@recent_games.inspect}"
    else
      @recent_games = [] # Fallback to empty array
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching Steam activity: #{e.message}"
    @recent_games = [] # Ensure a fallback in case of an error
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # POST /profiles or /profiles.json
  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      redirect_to profile_path(@profile), notice: "Profile created successfully!"
    else
      flash.now[:alert] = "Error creating profile: #{@profile.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: "Profile was successfully updated."
    else
      flash.now[:alert] = "Error updating profile: #{@profile.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy!
    redirect_to profiles_path, status: :see_other, notice: "Profile was successfully destroyed."
  end

  # Search profiles by name or game
  def search
    @profiles = Profile.all

    if params[:name].present?
      @profiles = @profiles.where("username LIKE ?", "%#{params[:name]}%")
    end

    if params[:game].present?
      @profiles = @profiles.joins(:games).where("games.name LIKE ?", "%#{params[:game]}%")
    end
  end
  
  # POST /profiles/:id/add_friend
  def add_friend
    if @profile.nil?
      flash[:alert] = "Profile not found."
      redirect_to profiles_search_path and return
    end
    # Check if the current user is already friends with the other profile
    if current_user.profile.friends.exists?(friend_profile_id: @profile.id)
      flash[:alert] = "You are already friends with this user."
    else
      # Create the friendship for the current user -> friend profile
      current_user.profile.friends.create!(friend_profile_id: @profile.id)

      # Create the reciprocal friendship for the friend profile -> current user
      @profile.friends.create!(friend_profile_id: current_user.profile.id)

      flash[:notice] = "You are now friends with #{@profile.username}."
    end

    redirect_to search_profiles_path
  end

  # GET /profiles/:id/wishlist
  def wishlist
    @wishlist = @profile.wishlist || []
    @wishlist_games = @profile.wishlist_games
  end

  # POST /profiles/:id/wishlist/add
  def add_to_wishlist
    game = {
      "appid" => params[:appid],
      "name" => params[:name],
      "developer" => params[:developer],
      "publisher" => params[:publisher],
      "players_2weeks" => params[:players_2weeks],
      "current_players" => params[:current_players]
    }
  
    @profile.wishlist << game unless @profile.wishlist.any? { |g| g["appid"] == game["appid"] }
  
    if @profile.save
      flash[:notice] = "Game added to your wishlist!"
    else
      flash[:alert] = "There was an error adding the game to your wishlist."
    end
  
    redirect_to wishlist_profile_path(@profile)
  end
  

  # DELETE /profiles/:id/wishlist/remove
  def remove_from_wishlist
    appid = params[:appid]

    @profile.remove_from_wishlist(appid)

    if @profile.save
      flash[:notice] = "Game successfully removed from wishlist!"
    else
      flash[:alert] = "Failed to remove game from wishlist. Please try again."
    end

    redirect_to wishlist_profile_path(@profile)  # Redirect to wishlist view
  end

  private

  # callbacks
  def set_profile
    @profile = Profile.find_by(id: params[:id])
    if @profile.nil?
      flash[:alert] = "Profile not found."
      redirect_to profiles_path
    end
  end

  # Only allow a list of trusted parameters through for profiles.
  def profile_params
    params.require(:profile).permit(:username, :bio, :steam_id, platforms: []).tap do |whitelisted|
      whitelisted[:platforms] = params[:profile][:platforms].split(',').map(&:strip) if params[:profile][:platforms].present?
    end
  end
end
