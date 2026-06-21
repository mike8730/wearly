class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :basic_auth

  def komoju
    payload = request.body.read
    event = JSON.parse(payload)

    return head :ok unless event["type"] == "payment.captured"

    payment_id = event.dig("data", "id")
    session_id = event.dig("data", "session")
    payment_type = event.dig("data", "payment_details", "type")

    # すでにこの決済IDで注文があるなら何もしない（冪等性）
    return head :ok if Order.exists?(payment_uuid: payment_id)

    pending = PendingOrder.find_by(session_id: session_id)
    return head :ok unless pending
    
    items = pending.order_items.map(&:symbolize_keys)

    form = OrderForm.new(
      pending.order_form_params.merge(
        order_items_attributes: items,
        payment_provider_type: payment_type,
        payment_uuid: payment_id
      )
    )

    if form.save
      pending.destroy
    end

    head :ok
  rescue JSON::ParserError
    head :bad_request
  end
end


