class RemoveIsWishlistFromGames < ActiveRecord::Migration[7.1]
  def change
    remove_column :games, :is_wishlist, :boolean
  end
end
