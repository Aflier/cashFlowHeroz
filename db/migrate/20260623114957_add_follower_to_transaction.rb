class AddFollowerToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :parent, null: true, foreign_key: { to_table: :transactions }
  end
end
