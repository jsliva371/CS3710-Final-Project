class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :friend_profile, null: false, foreign_key: { to_table: :profiles }

      t.timestamps
    end

    # Ensure unique friendships
    add_index :friends, [:profile_id, :friend_profile_id], unique: true
  end
end
