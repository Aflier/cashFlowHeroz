class AddXeroUuidToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :xero_uuid, :string
  end
end
