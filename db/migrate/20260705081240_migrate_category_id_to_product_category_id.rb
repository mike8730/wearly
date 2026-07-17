class MigrateCategoryIdToProductCategoryId < ActiveRecord::Migration[7.1]
  def up
    Item.find_each do |item|
      item.update!(product_category_id: item.category_id)
    end
  end

  def down
    Item.find_each do |item|
      item.update!(category_id: item.product_category_id)
    end
  end
end
