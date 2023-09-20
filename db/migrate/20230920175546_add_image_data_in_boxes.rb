class AddImageDataInBoxes < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :image_data, :text
  end
end
