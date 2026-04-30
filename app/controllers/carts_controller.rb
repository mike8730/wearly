class CartsController < ApplicationController
  def index
    @cart = current_user.cart || current_user.create_cart
    @cart_items = @cart.cart_items.includes(:item_variant)
  end
end

