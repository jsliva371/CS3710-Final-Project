class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:destroy]
  before_action :set_friend, only: [:destroy]

  # GET /friends or /friends.json
  def index
    @friends = Friend.all
  end

  # GET /friends/1 or /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends or /friends.json
  def create
    friend_profile = Profile.find(params[:friend_profile_id])
  
    # Check if the profiles are already friends in either direction
    if @profile.friend_profiles.include?(friend_profile)
      redirect_to profile_path(friend_profile), alert: "#{friend_profile.username} is already your friend."
    elsif friend_profile.friend_profiles.include?(@profile)
      redirect_to profile_path(friend_profile), alert: "#{friend_profile.username} has already added you as a friend."
    else
      # Create a friendship for the current user -> friend profile
      @profile.friend_profiles << friend_profile
      # Create a reciprocal friendship for the friend profile -> current user
      friend_profile.friend_profiles << @profile
  
      # Ensure the relationship is created in both directions (for both profiles)
      Friend.create(profile: @profile, friend_profile: friend_profile)
      Friend.create(profile: friend_profile, friend_profile: @profile)
  
      redirect_to profile_path(friend_profile), notice: "You are now friends with #{friend_profile.username}."
    end
  end
  
  

  
  
  

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html { redirect_to @friend, notice: "Friend was successfully updated." }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1 or /friends/1.json
  def destroy
    # Find the friend profile to remove
    friend_profile = Profile.find(params[:id])

    # Check if the friend is already in the user's friend list
    if @profile.friend_profiles.include?(friend_profile)
      # Remove the friend
      if @profile.friend_profiles.destroy(friend_profile)
        redirect_to profile_path(@profile), notice: "#{friend_profile.username} has been removed from your friends list."
      else
        redirect_to profile_path(@profile), alert: "Unable to remove friend."
      end
    else
      redirect_to profile_path(@profile), alert: "Friend not found in your friend list."
    end
  end

  private

  # Set the current user's profile
  def set_profile
    @profile = current_user.profile # Assuming each user has one profile
  end

  # Set the friend profile to remove
  def set_friend
    @friend = Profile.find(params[:id]) # Find the friend profile by ID
  end
end
