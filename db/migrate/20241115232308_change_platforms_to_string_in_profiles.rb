class ChangePlatformsToStringInProfiles < ActiveRecord::Migration[7.1]
  def change
    change_column :profiles, :platforms, :string
  end
end
