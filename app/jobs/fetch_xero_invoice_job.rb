
# app/jobs/fetch_xero_invoice_job.rb
class FetchXeroInvoiceJob < ApplicationJob
  def perform(invoice_guid, tenant_id)
    puts ">>>>>>> Doing the Job now"


    # 1. Fetch matching organization credentials
    token_record = Mission.find_by!(tenant_id: tenant_id)

    # 2. Build and establish an API client session
    xero_client = XeroRuby::ApiClient.new(credentials: {
      client_id: "6BA15BB4624A4F6FAC746B1B302B745B",
      client_secret: "-Z6LPwWU-LD3cmuCEchlkPxYLoTz-vOkVqsTYkvVkH8tQVMM",
      redirect_uri: "https://cash.heroz.app/xero/callback"
    })

    # 3. Populate existing OAuth tokens into client
    xero_client.set_token_set({
      "access_token" => token_record.access_token,
      "refresh_token" => token_record.refresh_token,
      "expires_at" => token_record.expires_at.to_i
    })

    # 4. Check for token expiration and refresh automatically
    if Time.current >= token_record.expires_at
      new_tokens = xero_client.refresh_token_set(xero_client.token_set)

      token_record.update!(
        access_token: new_tokens["access_token"],
        refresh_token: new_tokens["refresh_token"],
        expires_at: Time.current + new_tokens["expires_in"].to_i.seconds
      )
    end

    # 5. Fetch full deep invoice content records (including structural item arrays)
    response = xero_client.accounting_api.get_invoice(tenant_id, invoice_guid)
    invoice = response.invoices.first

    # 6. Read structural invoice parameters
    Rails.logger.info "--- Processing Xero Invoice ---"
    Rails.logger.info "Invoice Number: #{invoice.invoice_number}"
    Rails.logger.info "Contact Person: #{invoice.contact.name}"
    Rails.logger.info "Invoice Total: #{invoice.total}"

    invoice_due_date = (invoice.due_date ? invoice.due_date : 2.weeks.from_now)

    transaction = token_record.transactions.find_or_create_by!(xero_uuid: invoice.invoice_id) do |transaction|
      transaction.amount = invoice.total
      transaction.operation = (invoice.type == "ACCREC" ? 1 : 2)
      transaction.transaction_at = invoice_due_date # We need this here to pass validation
    end

    transaction.update(transaction_at: invoice_due_date, why: "#{invoice.invoice_number} - #{invoice.contact.name}", status: invoice.status, raw: invoice.to_s)

    transaction.calculate_cumulative_total

    # Extract deep object details
    invoice.line_items.each do |line|
      Rails.logger.info "Line Item: #{line.description} | Price: #{line.line_amount}"
    end
  end
end
