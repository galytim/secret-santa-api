class ChangeAdminIdToBigIntInBoxes < ActiveRecord::Migration[6.0]
  def change
    change_column :boxes, :admin_id, :bigint
  end
end
