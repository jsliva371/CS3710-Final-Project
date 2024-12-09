class AddWishlistToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :wishlist, :json
  end
end
