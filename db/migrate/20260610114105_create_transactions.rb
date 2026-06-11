class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.date :transaction_at
      t.string :why
      t.decimal :amount
      t.integer :operation
      t.string :business_account_balance
      t.boolean :vatable
      t.decimal :vat
      t.decimal :cumulative_total

      t.references :mission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
