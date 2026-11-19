class Transaction < ApplicationRecord
  belongs_to :mission

  belongs_to :parent, class_name: "Transaction", optional: true

  # The opposite side of the relationship
  has_one :child, class_name: "Transaction", foreign_key: "parent_id", dependent: :nullify

  enum :operation, { in: 1, out: 2, correction: 3 }
  enum :occurance, { weekly: 1, monthly: 2, quarterly: 3, annually: 4 }

  validates :transaction_at, :operation, :amount, presence: true

  before_validation :calculate_vat, if: :should_recalculate_vat?
  # after_validation :calculate_cumulative_total

  scope :ordered, -> { order(transaction_at: :asc, operation: :asc, created_at: :asc) }

  def calculate_cumulative_total
    # Make sure the first transaction is always what it should be
    transaction__first = mission.transactions.ordered.first

    if transaction__first.in? || transaction__first.correction?
      transaction__first.update(cumulative_total: mission.starting_balance + transaction__first.amount)
    else
      transaction__first.update(cumulative_total: mission.starting_balance - transaction__first.amount)
    end

    day_before = transaction_at.yesterday
    ordered_transactions = mission.transactions.ordered.where(transaction_at: day_before..)

    cumulative_total = 0

    ordered_transactions.each_with_index do |transaction, index|
      if index == 0
        # Trust the first one.
        cumulative_total = transaction.cumulative_total
      else
        next if transaction.amount.nil?
        next if cumulative_total.nil?

        cumulative_total = if transaction.in? || transaction.correction?
                             cumulative_total + transaction.amount
                           else

                             cumulative_total - transaction.amount
                           end
      end

      transaction.update(cumulative_total: cumulative_total)
    end
  end

  def duplicate_for_next
    transaction__new = dup

    puts ">>>> Occurance"
    case occurance
    when "weekly"
      transaction__new.transaction_at = transaction__new.transaction_at + 1.week
    when "monthly"
      transaction__new.transaction_at = transaction__new.transaction_at + 1.month
    when "quarterly"
      transaction__new.transaction_at = transaction__new.transaction_at + 3.months
    when "annually"
      transaction__new.transaction_at = transaction__new.transaction_at + 12.months
    end

    transaction__new.parent_id = id
    transaction__new.save!
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
