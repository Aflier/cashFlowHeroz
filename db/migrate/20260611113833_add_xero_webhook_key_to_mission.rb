class AddXeroWebhookKeyToMission < ActiveRecord::Migration[8.1]
  def change
    add_column :missions, :xero_webhook_key, :string
  end
end
