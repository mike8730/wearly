class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token  # Webhook は外部から来るので必須

  def komoju
    # 生のリクエストボディを取得
    payload = request.body.read

    # JSON をパース
    event = JSON.parse(payload) rescue nil

    # パースできなければ 400 を返す
    return head :bad_request if event.nil?

    # イベントタイプを取得
    event_type = event["type"]

    # 注文IDを取得（KOMOJU の payload に含まれる）
    order_id = event.dig("data", "metadata", "order_id")

    # 注文が見つからなければ 404
    order = Order.find_by(id: order_id)
    return head :not_found if order.nil?

    # イベントごとの処理
    case event_type
    when "payment.captured"
      order.update(status: :paid)
    when "payment.failed"
      order.update(status: :failed)
    end

    # Webhook には必ず 200 を返す
    head :ok
  end
end