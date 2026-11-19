module TransactionsHelper
  def button_to_duplicate(transaction)
    return unless transaction.occurance

    button_to icons__duplicate,
              duplicate_transaction_path(transaction),
              method: :patch,
              class: "btn-edit-sm"
  end
end
