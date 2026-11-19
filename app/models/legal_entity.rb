class LegalEntity < ApplicationRecord
  include EntitySuite
  has_many :missions
  has_many :entity_users
  has_many :users, through: :entity_users
end
