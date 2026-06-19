class AddPaymentProviderTypeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_provider_type, :string
  end
end
