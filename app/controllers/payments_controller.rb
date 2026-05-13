class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def checkout
    @order = current_user.orders.find(params[:order_id])

    response = Faraday.post(
      "https://api.komoju.com/api/v1/checkout_sessions",
      {
        amount: @order.total_price,
        currency: "JPY",
        return_url: order_url(@order),
        cancel_url: order_url(@order),
        metadata: {
          order_id: @order.id
        }
      }.to_json,
      {
        "Authorization" => "Bearer #{ENV['KOMOJU_SECRET_KEY']}",
        "Content-Type" => "application/json"
      }
    )

    unless response.success?
      Rails.logger.error("KOMOJU API Error: #{response.status} #{response.body}")
      redirect_to order_path(@order), alert: "決済ページの生成に失敗しました。" and return
    end

    session = JSON.parse(response.body)
    redirect_to session["url"], allow_other_host: true
  end
end