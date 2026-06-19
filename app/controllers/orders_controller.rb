class OrdersController < ApplicationController
  def new
    @cart = current_cart
    @order_form = OrderForm.new(user_id: current_user.id)

    @order_form.order_items_attributes = @cart.cart_items.map do |cart_item|
      {
        item_variant_id: cart_item.item_variant_id,
        quantity: cart_item.quantity
      }
    end
  end

  def create
    @cart = current_cart

    @order_form = OrderForm.new(order_form_params.merge(user_id: current_user.id))
    @order_form.order_items_attributes = @cart.cart_items.map { |ci| { item_variant_id: ci.item_variant_id, quantity: ci.quantity } }

    unless @order_form.valid?
      return render :new, status: :unprocessable_entity
    end

    # KOMOJU Checkout Session 作成
    conn = Faraday.new(url: "https://komoju.com") do |f|
      f.request :authorization, :basic, ENV["KOMOJU_SECRET_KEY"], ""
      f.options.timeout = 15
      f.options.open_timeout = 5
    end

    response = conn.post(
      "/api/v1/sessions",
      {
        amount: @cart.total_price,
        currency: "JPY",
        return_url: complete_orders_url,
        cancel_url: root_url
      }.to_json,
      { "Content-Type" => "application/json" }
    )

    session_data = JSON.parse(response.body)

    # 仮注文を保存
    PendingOrder.create!(
      user_id: current_user.id,
      session_id: session_data["id"],
      order_form_params: order_form_params.merge(user_id: current_user.id),
      order_items: @order_form.order_items_attributes
    )

    redirect_to session_data["session_url"], allow_other_host: true
  end

  def complete
    @order = current_user.orders.order(created_at: :desc).first

    unless @order&.paid?
      redirect_to orders_path, alert: "決済が完了していません"
      return
    end
  end

  def index
    @orders = current_user.orders.order(created_at: :desc).includes(:order_items)
  end

  def show
    @order = current_user.orders
                        .includes(order_items: { item_variant: [:item, :item_color] })
                        .find(params[:id])
    @order_items = @order.order_items
  end

  private

  def order_form_params
    params.require(:order_form).permit(
      :postal_code,
      :prefecture_id,
      :city,
      :address,
      :building,
      :phone_number
    )
  end
end
