class AddStatusToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :total_price, :integer, null: false
    add_reference :orders, :user, null: false, foreign_key: true
    add_column :orders, :status, :string, null: false, default: 'pending'
  end
end
