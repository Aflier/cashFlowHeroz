class Creditor < ApplicationRecord
  belongs_to :mission

  has_rich_text :notes
end
