class CartItemsController < ApplicationController
  def create
    @cart = current_user.cart || current_user.create_cart
    item_variant = ItemVariant.find(params[:item_variant_id])

    @cart_item = @cart.cart_items.find_by(item_variant_id: item_variant.id)

    if @cart_item
      @cart_item.quantity += 1
      @cart_item.save
    else
      @cart.cart_items.create(item_variant: item_variant, quantity: 1)
    end

    redirect_to carts_path, notice: "カートに追加しました"
  end

  def increase
    cart_item = CartItem.find(params[:id])
    cart_item.update(quantity: cart_item.quantity + 1)
    redirect_to carts_path
  end

  def decrease
    cart_item = CartItem.find(params[:id])
    if cart_item.quantity > 1
      cart_item.update(quantity: cart_item.quantity - 1)
    else
      cart_item.destroy
    end
    redirect_to carts_path
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to carts_path
  end
end
