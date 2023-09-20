class AddFieldImageDataIntableWishlists < ActiveRecord::Migration[7.0]
  def change
    add_column :wishlists, :image_data, :text
  end
end
