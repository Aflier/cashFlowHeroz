class CreateCreditors < ActiveRecord::Migration[8.1]
  def change
    create_table :creditors do |t|
      t.string :name
      t.decimal :starting_balance
      t.date :starting_balance_on
      t.decimal :current_balance
      t.date :current_balance_on
      t.belongs_to :mission, null: false, foreign_key: true
      t.decimal :monthly_payment

      t.timestamps
    end
  end
end
