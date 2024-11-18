class AddSteamIdToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :steam_id, :string
  end
end
