class AddProductCategoryIdToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :product_category_id, :integer
  end
end
