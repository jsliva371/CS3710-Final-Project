require 'rails_helper'

RSpec.describe "User and Profile Features", type: :system do
  before do
    driven_by(:rack_test) # Use Capybara's rack_test driver for system tests
  end

  let(:user) { User.create!(email: "user@example.com", password: "password", firstname: "John", lastname: "Doe") }

  describe "User Login" do
    it "allows a user with valid credentials to log in successfully" do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Log in"

      expect(page).to have_content "Welcome back"
      expect(current_path).to eq(root_path)
    end

    it "prevents login and displays an error with incorrect credentials" do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "wrongpassword"

      click_button "Log in"

      expect(page).to have_content "Invalid Email or password"
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe "Game Profile Creation" do
    let(:profile) { Profile.create!(user: user, username: "johndoe", platforms: ["PC", "Xbox"], bio: "Gamer") }
    before do
      sign_in user
    end
  
    it "allows a logged-in user to create a game profile" do
      visit new_profile_game_path(profile_id: profile.id)
      fill_in "Name", with: "Apex Legends"
      fill_in "Rank", with: "Platinum"
      fill_in "Main", with: "Wraith"
      fill_in "Join date", with: "02-07-2018"

      click_button "Create Game"
  
      expect(page).to have_content "Apex Legends"
      expect(page).to have_content "Platinum"
      expect(page).to have_content "Wraith"
    end

    it "displays an error when required fields are empty" do
      visit new_profile_game_path(profile_id: profile.id)
      click_button "Create Game"

      expect(page).to have_content "errors prohibited this game from being saved:"
      expect(page).to have_content "Name can't be blank"
    end
  end
end
