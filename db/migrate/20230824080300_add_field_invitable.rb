class AddFieldInvitable < ActiveRecord::Migration[7.0]
  def change
    add_column :boxes, :invitable, :boolean, :default => true
  end
end
