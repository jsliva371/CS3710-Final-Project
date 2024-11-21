class ProfileFix < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :platforms
      t.text :bio
      t.references :user, null: false, foreign_key: true
      t.string :steam_id

      t.timestamps
    end
  end
end
