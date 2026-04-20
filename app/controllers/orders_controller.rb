class OrdersController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      @cart = current_user.cart
      @cart_items = @cart.cart_items
      @order = Order.new(user_id: current_user.id, status: :pending, total_price: 0)
      if @order.save
        @cart_items.each do |cart_item|
          if cart_item.quantity > cart_item.item_variant.stock_quantity
            redirect_to carts_path, alert: "#{cart_item.item_variant.item.name}の在庫が不足しています。数量を変更してください。" and return
          end

          OrderItem.create!(
            order: @order,
            item_variant_id: cart_item.item_variant_id,
            quantity: cart_item.quantity,       
            price: cart_item.item_variant.price  
          ) 
        
          variant = cart_item.item_variant
          variant.stock_quantity -= cart_item.quantity
          variant.save!
        end
        @order.update!(total_price: @order.calculate_total_price)
        @cart_items.destroy_all
        redirect_to orders_path, notice: "注文が完了しました。" and return
      else
        redirect_to carts_path, alert: "注文に失敗しました。" and return
      end
    end
  end
end
