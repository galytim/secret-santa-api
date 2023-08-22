class ChangeColumnName < ActiveRecord::Migration[7.0]
  def change
rename_column :boxes, :nameBox, :name
#Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
