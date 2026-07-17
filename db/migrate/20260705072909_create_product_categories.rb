class CreateProductCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :product_categories, id: false do |t|
      t.primary_key :id
      t.string :name, null: false
      t.timestamps
    end
  end
end
