class ChangeColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :boxes, :nameBox, :name
  end
end
