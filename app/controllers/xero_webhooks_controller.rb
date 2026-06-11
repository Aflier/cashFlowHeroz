
# app/controllers/xero_webhooks_controller.rb
class XeroWebhooksController < ApplicationController
  # Disable Rails CSRF protection specifically for Xero's third-party endpoint
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access only: %i[ receive ]

  def receive
    # 1. Capture the unparsed text body string
    raw_body = request.raw_post
    xero_signature = request.headers["X-Xero-Signature"]

    # 2. Re-create the HMAC-SHA256 signature using your secret webhook key
    calculated_signature = Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new("sha256"),
        Mission.find(1).xero_webhook_key,
        raw_body
      )
    ).strip

    # 3. Handle signature verification failure
    if xero_signature != calculated_signature
      return head :unauthorized # HTTP 401 prevents active webhook verification
    end

    # 4. Handle a successful validation request
    payload = JSON.parse(raw_body)

    puts ">>>>>>>>>>>>> Recieved an INVOICE"


    # Offload event logs cleanly to background processes
    payload["events"]&.each do |event|
      if event["eventCategory"] == "INVOICE"
        FetchXeroInvoiceJob.perform_later(
          event["resourceId"], # This is the unique Invoice GUID
          event["tenantId"]     # This is the Xero Organisation ID
        )
      end
    end

    head :ok # Return quick HTTP 200 to acknowledge delivery
  end
end
