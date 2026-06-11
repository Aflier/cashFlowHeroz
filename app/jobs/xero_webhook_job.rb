# app/jobs/xero_webhook_job.rb
class XeroWebhookJob < ApplicationJob
  queue_as :default

  def perform(events)
    resource_id = event["resourceId"]     # e.g., Invoice ID or Contact ID
    event_type  = event["eventType"]      # e.g., "Create", "Update"
    category    = event["eventCategory"]  # e.g., "INVOICE", "CONTACT"

    case category
    when "INVOICE"

      puts ">>>>>>>>> INVOICE #{event}"


      # Implement your system sync logic here
      # (e.g., fetch the full invoice using the xero-ruby SDK)
    when "CONTACT"
      # Sync updated contact info
    end
  end
end
