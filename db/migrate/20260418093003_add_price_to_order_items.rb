class AddPriceToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :price, :integer, null: false
  end
end
