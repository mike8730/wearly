class CreatePendingOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :pending_orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_id, null: false
      t.text :order_form_params, null: false
      t.text :order_items, null: false

      t.timestamps
    end

    add_index :pending_orders, :session_id, unique: true
  end
end