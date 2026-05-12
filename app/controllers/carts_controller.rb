class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(:item_variant)
  end

  def checkout
    @cart = current_cart

    @cart.cart_items.includes(item_variant: [:item, :item_color]).each do |cart_item|
      variant = cart_item.item_variant

      if variant.stock_quantity < cart_item.quantity
        flash[:alert] = "#{variant.item.name}（#{variant.color.name} / #{variant.size.name}）の在庫が不足しています。"
        return redirect_to carts_path
      end
    end

    redirect_to new_order_path
  end
end

