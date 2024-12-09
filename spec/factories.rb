FactoryBot.define do
  factory :friend do
    profile_id { 1 }
    friend_profile_id { 1 }
  end

    factory(:user) do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      email { "student1@msudenver.edu" }
      password { "password" }
      password_confirmation { "password" }
    end
   end
   