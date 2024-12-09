class Friend < ApplicationRecord
    belongs_to :profile
    belongs_to :friend_profile, class_name: 'Profile'
    
    validates :profile_id, uniqueness: { scope: :friend_profile_id }
end  