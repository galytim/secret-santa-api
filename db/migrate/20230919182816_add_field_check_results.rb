class AddFieldCheckResults < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :isCheckResult, :boolean, :default => false
    
  end
end
