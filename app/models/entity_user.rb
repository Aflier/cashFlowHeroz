class EntityUser < ApplicationRecord
  belongs_to :legal_entity
  belongs_to :user

  enum :role, { responsible: 1, contributor: 2, observer: 3, suspended: 4 }, default: :observer
end
