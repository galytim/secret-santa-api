# db/migrate/YYYYMMDDHHMMSS_create_pairs.rb

class CreatePairs < ActiveRecord::Migration[6.0]
  def change
    create_table :pairs do |t|
      t.references :giver, foreign_key: { to_table: :users }, null: false
      t.references :recipient, foreign_key: { to_table: :users }, null: false
      t.references :box, foreign_key: true, null: false

      t.timestamps
    end

    # Общий индекс для полей giver_id, recipient_id и box_id
    add_index :pairs, [:giver_id, :recipient_id, :box_id], name: 'index_pairs_on_giver_and_recipient_and_box'
  end
end
