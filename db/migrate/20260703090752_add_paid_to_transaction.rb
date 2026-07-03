class AddPaidToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :paid, :boolean
  end
end
