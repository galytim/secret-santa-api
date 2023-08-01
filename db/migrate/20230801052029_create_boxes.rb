class CreateBoxes < ActiveRecord::Migration[7.0]
  def change
    create_table :boxes do |t|
      t.string :nameBox
      t.date :dateFrom
      t.date :dateTo
      t.integer :priceFrom
      t.integer :priceTo
      t.string :place
      t.string :image

      t.timestamps
    end
  end
end
