module TransactionsHelper
  def button_to_duplicate(transaction)
    return unless transaction.occurance
    return if transaction.child

    button_to icons__duplicate,
              duplicate_transaction_path(transaction, page: params[:page]),
              method: :patch,
              class: "btn-edit-sm"
  end
end
