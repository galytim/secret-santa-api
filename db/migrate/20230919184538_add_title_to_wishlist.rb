class AddTitleToWishlist < ActiveRecord::Migration[7.0]
  def change
    add_column :wishlists, :title, :string
  end
end
