class AddKomojuSessionIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :komoju_session_id, :string
  end
end
