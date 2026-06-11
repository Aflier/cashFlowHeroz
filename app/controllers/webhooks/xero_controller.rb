
module Webhooks
  class XeroController < ApplicationController
    # Skip CSRF token checks for API/Webhook controllers
    skip_before_action :verify_authenticity_token

    def create
      # 1. Fetch Xero's signature and read the raw unparsed payload
      xero_signature = request.headers["X-Xero-Signature"]
      raw_payload = request.raw_post

      # 2. Validate the signature
      if valid_signature?(raw_payload, xero_signature)
        # 3. Parse and pass valid events to a background job
        payload_data = JSON.parse(raw_payload)

        if payload_data["events"].any?
          XeroWebhookJob.perform_later(payload_data["events"])
        end

        # 4. Respond with 200 OK and no body or cookies (required by Xero)
        head :ok
      else
        # Fail immediately if the signature does not match
        head :unauthorized
      end
    end

    private

    def valid_signature?(payload, signature)
      return false if signature.blank? || payload.blank?

      # Calculate HMAC-SHA256 hash using your Webhook Key
      secret = "BYHwLxiI5VzyNjJokJoZahvKEXDHohdzcB9XFNOlk1Rncu01aK/OXSFe5ul1iGY0v+uaCcwsxeJm8Luasg/6hg=="
      computed_hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), secret, payload)
      encoded_hash = Base64.strict_encode64(computed_hash)

      # Secure comparison prevents timing attacks
      ActiveSupport::SecurityUtils.secure_compare(encoded_hash, signature)
    end
  end
end
