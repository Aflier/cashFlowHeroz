class Transaction < ApplicationRecord
  belongs_to :mission

  belongs_to :parent, class_name: "Transaction", optional: true

  # The opposite side of the relationship
  has_one :child, class_name: "Transaction", foreign_key: "parent_id", dependent: :nullify

  enum :operation, { credit: 1, out: 2, correction: 3, vat_payment: 4 }
  enum :occurance, { no_repeat: nil, weekly: 1, monthly: 2, quarterly: 3, annually: 4 }
  enum :ignore, { previous: nil, ignore_this_and_after: 1 }

  validates :transaction_at, :operation, :amount, presence: true

  before_validation :calculate_vat, if: :should_recalculate_vat?
  # after_validation :calculate_cumulative_total

  scope :ordered, -> { order(transaction_at: :asc, operation: :asc, created_at: :asc) }

  def calculated_vat
    Transaction.where(transaction_at: 4.months.ago.beginning_of_month..2.months.ago.end_of_month).previous.credit.sum(:vat) -
      Transaction.where(transaction_at: 4.months.ago.beginning_of_month..2.months.ago.end_of_month).previous.out.sum(:vat)
  end

  def calculate_cumulative_total
    # Make sure the first transaction is always what it should be
    transaction__first = mission.transactions.ordered.first

    if transaction__first.credit? || transaction__first.correction?
      transaction__first.update(cumulative_total: mission.starting_balance + transaction__first.amount)
    else
      transaction__first.update(cumulative_total: mission.starting_balance - transaction__first.amount)
    end

    transaction_at.yesterday
    ordered_transactions = mission.transactions.ordered # .where(transaction_at: day_before..) TODO:Make it so we are more intelligent

    cumulative_total = 0

    ordered_transactions.each_with_index do |transaction, index|
      if index == 0
        # Trust the first one.
        cumulative_total = transaction.cumulative_total
      else
        next if transaction.ignore_this_and_after?
        next if transaction.amount.nil?
        next if cumulative_total.nil?

        cumulative_total = if transaction.credit? || transaction.correction?
                             cumulative_total + transaction.amount
                           else

                             cumulative_total - transaction.amount
                           end
      end

      transaction.update(cumulative_total: cumulative_total)
    end
  end

  def propogate_ignore
    return if child.nil?
    return unless ignore_previously_changed?

    child.update(ignore: ignore)
    child.propogate_ignore
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

    # NOTE: When we are repeating an invoice make sure the repeat does not look like a xero import
    transaction__new.xero_uuid = nil

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
