class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    @profile = current_user.profile
  
    # Ensure SteamService is initialized with API key and the user's steam_id
    steam_service = SteamService.new("4C12A9733AD456CBF59B59B7A46F5BAB", @profile.steam_id)
  
    # Fetch recent Steam activity only if there's a steam_id
    if @profile.steam_id.present?
      Rails.logger.debug "Calling fetch_recently_played_games for Steam ID: #{@profile.steam_id}" # Debugging statement
      @recent_games = steam_service.fetch_recently_played_games
      Rails.logger.debug "Recent games: #{@recent_games.inspect}" # Log the fetched games
    else
      @recent_activity = [] # If no Steam ID, show no activity
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching Steam activity: #{e.message}"
    @recent_activity = [] # In case of error, set to empty array
  end
  

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    @profile = current_user.profile
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

  # POST /profiles/:id/games
  def create_game
    @profile = current_user.profile
    @game = @profile.games.build(game_params)

    if @game.save
      redirect_to @profile, notice: "Game added successfully!"
    else
      render :show
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Only allow a list of trusted parameters through for profiles.
  def profile_params
    params.require(:profile).permit(:username, :bio, :steam_id, platforms: []).tap do |whitelisted|
      whitelisted[:platforms] = params[:profile][:platforms].split(',').map(&:strip) if params[:profile][:platforms].present?
    end
  end

  # Strong parameters for games
  def game_params
    params.require(:game).permit(:name, :rank, :main, :join_date, :is_wishlist, achievements: [])
  end
end
