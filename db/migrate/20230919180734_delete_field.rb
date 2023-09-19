class DeleteField < ActiveRecord::Migration[7.0]
  def change
    remove_column :boxes, :dateTo
  end
end
