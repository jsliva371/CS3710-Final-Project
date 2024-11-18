class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :platforms, array: true, default: []
      t.text :bio
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
