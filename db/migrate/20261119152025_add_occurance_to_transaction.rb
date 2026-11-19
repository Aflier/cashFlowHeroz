class AddOccuranceToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :occurance, :integer
  end
end
