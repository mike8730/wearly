class CreateItemVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :item_variants do |t|
      t.timestamps
      t.references :item, null: false, foreign_key: true
      t.references :size, null: false, foreign_key: true
      t.references :color, null: false, foreign_key: true
      t.integer  :stock_quantity, null: false
      t.integer  :price, null: false
    end
  end
end
