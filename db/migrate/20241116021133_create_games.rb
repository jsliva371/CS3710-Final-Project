class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :name
      t.string :rank
      t.string :main
      t.text :achievements, default: ""
      t.date :join_date
      t.boolean :is_wishlist, default: false

      t.timestamps
    end
  end
end
