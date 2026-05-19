class WebhooksController < ApplicationController
  # Webhook は外部から来るので CSRF 無効化
  skip_before_action :verify_authenticity_token
  skip_before_action :basic_auth, only: :komoju

  def komoju
    # 生の JSON を取得
    payload = request.body.read

    # JSON パース（失敗したら 400）
    event = JSON.parse(payload) rescue nil
    return head :bad_request if event.nil?

    # イベントタイプ
    event_type = event["type"]

    # metadata から order_id を取得（string）
    order_id = event.dig("data", "metadata", "order_id")
    return head :bad_request if order_id.blank?

    # Order を特定（見つからなければ 404）
    order = Order.find_by(id: order_id)
    return head :not_found if order.nil?

    # イベントごとの処理
    case event_type
    when "payment.captured"
      order.update!(status: :paid)
    when "payment.failed"
      order.update!(status: :failed)
    end

    # Webhook は必ず 200 を返す
    head :ok
  end
end