class AddRawToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :raw, :text
  end
end
