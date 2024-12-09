require 'rails_helper'

RSpec.describe User, type: :model do

  # Validate presence of email
  it "validates presence of email" do
    user = User.new(email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

it 'validates uniqueness of email' do
      User.create!(email: "test@example.com", password: "password", firstname: "John", lastname: "Doe")
      duplicate_user = User.new(email: "test@example.com", password: "password", firstname: "Jane", lastname: "Smith")

      expect(duplicate_user.valid?).to be false
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

  # Validate presence of first and last name
  it "validates presence of first and last name" do
    user = User.new(firstname: nil, lastname: nil)
    expect(user).not_to be_valid
    expect(user.errors[:firstname]).to include("can't be blank")
    expect(user.errors[:lastname]).to include("can't be blank")
  end

  # Validate profile association
  it "creates a profile associated with the user" do
    user = User.create!(email: "user@example.com", password: "password", firstname: "John", lastname: "Doe")
    profile = user.create_profile!(username: "gamer123", bio: "Hello!")
    expect(profile.user_id).to eq(user.id)
  end
end
