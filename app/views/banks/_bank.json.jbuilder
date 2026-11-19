json.extract! bank, :id, :name, :starting_balance, :starting_balance_on, :current_balance, :current_balance_on, :mission_id, :created_at, :updated_at
json.url bank_url(bank, format: :json)
