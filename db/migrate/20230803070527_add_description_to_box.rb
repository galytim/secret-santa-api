class AddDescriptionToBox < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :description, :string
  end
end
