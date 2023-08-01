class AddAdminIdToBoxes < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :admin_id, :integer
  end
end
