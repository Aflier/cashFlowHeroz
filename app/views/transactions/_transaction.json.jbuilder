json.extract! transaction, :id, :transaction_at, :why, :amount, :operation, :business_account_balance, :vatable, :vat, :mission_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
