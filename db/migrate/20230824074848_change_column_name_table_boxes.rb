class ChangeColumnNameTableBoxes < ActiveRecord::Migration[7.0]
  def change
    rename_column :boxes, :dateFrom, :dateTo
  
  end
end
