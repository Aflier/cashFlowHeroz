class Transaction < ApplicationRecord
  belongs_to :mission

  belongs_to :parent, class_name: "Transaction", optional: true

  # The opposite side of the relationship
  has_one :child, class_name: "Transaction", foreign_key: "parent_id"


  enum :operation, { in: 1, out: 2, correction: 3 }

  validates :transaction_at, :operation, :amount, presence: true

  before_validation :calculate_vat, if: :should_recalculate_vat?
  # after_validation :calculate_cumulative_total

  scope :ordered, -> { order(transaction_at: :asc, operation: :asc, created_at: :asc) }

  def calculate_cumulative_total
    # Make sure the first transaction is always what it should be
    transaction__first = mission.transactions.ordered.first

    if transaction__first.cumulative_total.nil?
      if transaction__first.in? || transaction__first.correction?
        transaction__first.update(cumulative_total: transaction__first.amount)
      else
        transaction__first.update(cumulative_total: - transaction__first.amount)
      end
    end

    day_before = transaction_at.yesterday
    ordered_transactions = mission.transactions.ordered.where(transaction_at: day_before..)

    cumulative_total = 0

    ordered_transactions.each_with_index do |transaction, index|
      if index == 0
        # Trust the first one.
        cumulative_total = transaction.cumulative_total
      else
        if transaction.in? || transaction.correction?
          cumulative_total = cumulative_total + transaction.amount
        else
          cumulative_total = cumulative_total - transaction.amount
        end
      end

    transaction.update(cumulative_total: cumulative_total)
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

  self.cumulative_total = nil
  end
end
