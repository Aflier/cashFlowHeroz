class Transaction < ApplicationRecord
  belongs_to :mission

  enum :operation, { in: 1, out: 2, correction: 3 }

  validates :transaction_at, :operation, :amount, presence: true

  before_validation :calculate_vat, if: :should_recalculate_vat?
  # after_validation :calculate_cumulative_total

  scope :ordered, -> { order(transaction_at: :asc, operation: :asc, created_at: :asc) }

  def calculate_cumulative_total
    day_before = transaction_at.yesterday
    last_tx = nil
    ordered_transactions = mission.transactions.ordered.where(transaction_at: day_before..)

    ordered_transactions.each_with_index do |transaction, index|
      if index == 0
        if transaction.cumulative_total.nil?
          if transaction.in? || transaction.correction?
            transaction.update(cumulative_total: 0 + transaction.amount)
          else
            transaction.update(cumulative_total: 0 - transaction.amount)
          end
        end
        last_tx = transaction
      else
        if transaction.in? || transaction.correction?
          transaction.update(cumulative_total: last_tx.cumulative_total + transaction.amount)
        else
          transaction.update(cumulative_total: last_tx.cumulative_total - transaction.amount)
        end
      end
      last_tx = transaction
    end
  end

  private

  def should_recalculate_vat?
    will_save_change_to_amount? || will_save_change_to_vatable?
  end

  def calculate_vat
    return nil unless vatable?
    return nil if amount.blank?
    self.vat = (amount / 6).round(2)
  end
end
