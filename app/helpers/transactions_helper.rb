module TransactionsHelper
  def button_to_duplicate(transaction)
    return if transaction.no_repeat?
    return if transaction.child

    button_to icons__duplicate,
              duplicate_transaction_path(transaction, page: params[:page]),
              method: :patch,
              class: "btn-edit-sm"
  end

  def transaction_classes(transaction)
    return "bg-gray-200 text-gray-600" if transaction.ignore_this_and_after?

    "paid-transaction" if transaction.status == "PAID" || transaction.paid
  end
end
