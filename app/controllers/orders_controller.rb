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

    @order = OrderForm.new(
      order_form_params.merge(user_id: current_user.id)
    )

    @order.order_items_attributes = @cart.cart_items.map do |cart_item|
      {
        item_variant_id: cart_item.item_variant.id,
        quantity: cart_item.quantity
      }
    end

    if @order.save
      order = @order.order

      # KOMOJU API 接続
      conn = Faraday.new(url: "https://komoju.com") do |f|
        f.request :authorization, :basic, ENV["KOMOJU_SECRET_KEY"], ""
        f.options.timeout = 15
        f.options.open_timeout = 5
      end

      # Checkout Session 作成
      response = conn.post(
        "/api/v1/sessions",
        {
          amount: order.total_price,
          currency: "JPY",
          payment_types: [order.payment_method],
          return_url: order_url(order, completed: true),

          # webhook で order_id を取得するために必要
          payment_data: {
            metadata: {
              order_id: order.id.to_s
            }
          }

        }.to_json,
        {
          "Content-Type" => "application/json"
        }
      )

      unless response.success?
        Rails.logger.error(
          "KOMOJU API Error: #{response.status} #{response.body}"
        )

        redirect_to order_path(order),
                    alert: "決済ページの生成に失敗しました。"
        return
      end

      session_data = JSON.parse(response.body)

      order.update!(
        komoju_session_id: session_data["id"]
      )

      redirect_to session_data["session_url"],
        allow_other_host: true

      return

    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @orders = current_user.orders
                          .order(created_at: :desc)
                          .includes(:order_items)
  end

  def show
    @order = current_user.orders
                          .includes(
                            order_items: {
                              item_variant: [:item, :item_color]
                            }
                          )
                          .find(params[:id])

    @order_items = @order.order_items
  end

  def cancel
    @order = current_user.orders.find(params[:id])

    if @order.pending? || @order.paid?
      @order.update!(status: :cancelled)

      @order.order_items.each do |item|
        variant = item.item_variant

        variant.update!(
          stock_quantity: variant.stock_quantity + item.quantity
        )
      end

      redirect_to orders_path,
                  notice: "注文をキャンセルしました"

    else
      redirect_to order_path(@order),
                  alert: "この注文はキャンセルできません"
    end
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
