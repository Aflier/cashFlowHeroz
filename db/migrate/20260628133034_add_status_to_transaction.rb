class AddStatusToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :status, :string
  end
end
