class ChangePaymentMethodToStringInOrders < ActiveRecord::Migration[7.1]
  def change
    change_column :orders, :payment_method, :string, null: false
  end
end
