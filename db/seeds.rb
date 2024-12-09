require 'faker'

# Clear existing data
Friend.destroy_all
Profile.destroy_all
User.destroy_all

# Create sample users and profiles
users = []
profiles = []

10.times do
  # Create a user
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password123',
    password_confirmation: 'password123'
  )
  users << user

  # Create a profile associated with the user
  profiles << Profile.create!(
    username: Faker::Internet.username(specifier: 5..10),
    bio: Faker::Lorem.sentence(word_count: 10),
    platforms: ["PC", "Xbox", "PlayStation"].sample(2),
    user_id: user.id
  )
end

# Create friendships (symmetric relationships)
profiles.each_with_index do |profile, index|
  next if index == profiles.length - 1 # Skip the last one

  # Add friendship to the next profile
  Friend.create!(profile_id: profile.id, friend_profile_id: profiles[index + 1].id)
  Friend.create!(profile_id: profiles[index + 1].id, friend_profile_id: profile.id)
end

puts "Seeded #{User.count} users, #{Profile.count} profiles, and #{Friend.count} friendships."
