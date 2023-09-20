class DeleteColumnInBoxes < ActiveRecord::Migration[7.0]
  def change
    remove_column :boxes, :image
  end
end
