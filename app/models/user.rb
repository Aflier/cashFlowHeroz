class User < ApplicationRecord
  include ConnectorModel
  include SuperTableFilter
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :mission_users
  has_many :missions, through: :mission_users
  has_many :entity_users
  has_many :legal_entities, through: :entity_users

  normalizes :email, with: ->(e) { e.strip.downcase }

  # Method to find or create a user from the OAuth hash
  def self.from_omniauth(auth)
    if (existing_user = User.find_by(email: auth.info.email, uid: nil))
      existing_user.update(provider: auth.provider, uid: auth.uid, in_mission_control: true)
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |new_user|
        new_user.email = auth.info.email
        # Generate a password for OAuth-only users to satisfy has_secure_password
        new_user.password = "password"
        new_user.in_mission_control = true
      end
    end
  end
end
