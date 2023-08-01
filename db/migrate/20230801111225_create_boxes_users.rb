class CreateBoxesUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :boxes_users, id: false do |t|
      t.belongs_to :box
      t.belongs_to :user
      t.timestamps
    end
  end
end
