class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def checkout
    @order = current_user.orders.find(params[:order_id])
    # ここに後で KOMOJU の Checkout セッション作成処理を記述する
  end
end

