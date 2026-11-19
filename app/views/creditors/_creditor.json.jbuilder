json.extract! creditor, :id, :name, :starting_balance, :starting_balance_on, :current_balance, :current_balance_on, :mission_id, :monthly_payment, :created_at, :updated_at
json.url creditor_url(creditor, format: :json)
