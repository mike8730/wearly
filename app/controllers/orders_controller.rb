class OrdersController < ApplicationController

  def new
    @cart = current_cart
    @order = OrderForm.new(user_id: current_user.id)
    @order.order_items_attributes = @cart.cart_items.map do |cart_item|
      {
        item_variant_id: cart_item.item_variant_id,
        quantity: cart_item.quantity
      }
    end
  end

  def create
    @cart = current_cart
    @order = OrderForm.new(order_form_params.merge(user_id: current_user.id))
    @order.order_items_attributes = @cart.cart_items.map do |cart_item|
      {
        item_variant_id: cart_item.item_variant.id,
        quantity: cart_item.quantity
      }
    end
    
    if @order.save
      redirect_to orders_path, notice: "注文が完了しました"      
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @orders = current_user.orders
      .order(created_at: :desc)
      .includes(:order_items)
  end

  private
  def order_form_params
    params.permit(
      :postal_code,
      :prefecture_id,
      :city,
      :address,
      :building,
      :phone_number,
      :payment_method
    )
  end

end
