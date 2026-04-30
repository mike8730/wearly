class AddItemColorRefToItemVariants < ActiveRecord::Migration[7.1]
  def change
    add_column :item_variants, :item_color_id, :bigint
    add_index :item_variants, :item_color_id
  end
end