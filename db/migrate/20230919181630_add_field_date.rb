class AddFieldDate < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :dateTo, :date
  end
end
