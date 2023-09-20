class AddImageDatainUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :image_data, :text
  end
end
