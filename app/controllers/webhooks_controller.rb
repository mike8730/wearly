class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :basic_auth, only: :komoju

  KOMOJU_SECRET = ENV["KOMOJU_WEBHOOK_SECRET"]

  def komoju
    payload = request.body.read

    return head :bad_request unless valid_signature?(payload)

    event = JSON.parse(payload)
    event_type = event["type"]

    case event_type
    when "payment.captured"
      session_id = event.dig("data", "session")
      order = Order.find_by(komoju_session_id: session_id)

      if order.present?
        order.update!(status: :paid)
      else
        Rails.logger.error("KOMOJU: Order not found for session #{session_id}")
      end

    else
      Rails.logger.info("UNHANDLED EVENT TYPE: #{event_type}")
    end

    head :ok

  rescue JSON::ParserError
    head :bad_request

  rescue => e
    Rails.logger.error("KOMOJU WEBHOOK ERROR: #{e.class} #{e.message}")
    head :internal_server_error
  end

  private

  def valid_signature?(payload)
    signature = request.headers["X-Komoju-Signature"]
    return true if signature.blank?

    expected = OpenSSL::HMAC.hexdigest(
      "SHA256",
      KOMOJU_SECRET,
      payload
    )

    ActiveSupport::SecurityUtils.secure_compare(signature, expected)
  end
end
