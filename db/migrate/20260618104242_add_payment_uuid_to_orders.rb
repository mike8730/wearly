class AddPaymentUuidToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_uuid, :string
    add_index :orders, :payment_uuid, unique: true
  end
end
