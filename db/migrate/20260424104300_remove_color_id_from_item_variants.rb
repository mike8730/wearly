class RemoveColorIdFromItemVariants < ActiveRecord::Migration[7.1]
  def change
    if foreign_key_exists?(:item_variants, :colors)
      remove_foreign_key :item_variants, :colors
    end

    if index_exists?(:item_variants, :color_id)
      remove_index :item_variants, :color_id
    end

    remove_column :item_variants, :color_id, :bigint
  end
end

