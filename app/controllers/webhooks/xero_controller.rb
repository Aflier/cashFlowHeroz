
module Webhooks
  class XeroController < ApplicationController
    # Skip CSRF token checks for API/Webhook controllers
    skip_before_action :verify_authenticity_token
    allow_unauthenticated_access only: %i[ create ]

    def create
      puts ">>>>>>> Starting to handle Xero Webhook"

      # 1. Fetch Xero's signature and read the raw unparsed payload
      xero_signature = request.headers["X-Xero-Signature"]
      raw_payload = request.raw_post

      # 2. Validate the signature
      if valid_signature?(raw_payload, xero_signature)
        # 3. Parse and pass valid events to a background job

        events = params[:events] || []

        events.each do |event|
          next unless event[:eventCategory] == "INVOICE"

          # 2. Extract key identifiers
          invoice_guid = event[:resourceId]
          tenant_id = event[:tenantId]
          # 3. Initialize your authenticated Xero client
          # Ensure you have refreshed/retrieved valid OAuth2 tokens for this tenant
          xero_client = initialize_xero_client

          begin
            # 4. Request full invoice details
            # The single get_invoice method returns line_items by default
            response = xero_client.accounting_api.get_invoice(tenant_id, invoice_guid)
            invoice = response.invoices.first
            # 5. Safely access your invoice line details
            puts "Invoice Number: #{invoice.invoice_number}"
            puts "Total Amount: #{invoice.total}"
            invoice.line_items.each do |item|
              puts "Item: #{item.description} - #{item.line_amount}"
            end

          rescue XeroRuby::ApiError => e
             Rails.logger.error "Xero API Exception: #{e.message} (Code: #{e.code})"
          end
        end
          # 4. Respond with 200 OK and no body or cookies (required by Xero)
          head :ok
      else
          # Fail immediately if the signature does not match
          head :unauthorized
      end
    end

    private

    def initialize_xero_client
      client = XeroRuby::ApiClient.new(credentials: {
        client_id: "A2A6438EF0474E849498A5725D407E9D",
        client_secret: "MP1JXABIEBfMLurERFECFGfdze6Tu3Gteno2Ht9f0sLI97lX",
        redirect_uri: "https://portal.aflier.com/auth/xero_oauth2/callback"
      })

      # Load your stored token set for this user connection
      # client.refresh_token_set(stored_token_set)
      client
    end

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
