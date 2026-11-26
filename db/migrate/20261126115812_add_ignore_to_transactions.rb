class AddIgnoreToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :ignore, :integer
  end
end
