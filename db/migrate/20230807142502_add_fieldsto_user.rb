class AddFieldstoUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :dateOfBirth, :date, default: nil
    add_column :users, :sex, :integer, default: 2
    add_column :users, :phone, :string, limit: 12, default: nil
  end
end
