class AddItemColorIdToItemVariants < ActiveRecord::Migration[7.1]
  def change
    # add_reference :item_variants, :item_color, foreign_key: true
    # ↑ これをコメントアウト or 削除
  end
end