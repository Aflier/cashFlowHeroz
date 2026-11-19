module UserSuite
  extend ActiveSupport::Concern
  included do
    def self.from_omniauth(auth)
      if (existing = User.find_by(email: auth.info.email)) and existing.provider.blank?
        existing.update(provider: auth.provider, uid: auth.uid, in_mission_control: true)
        existing
      else
        where(provider: auth.provider, uid: auth.uid).first_or_create do |new_user|
          new_user.email = auth.info.email
          # Generate a password for OAuth-only users to satisfy has_secure_password
          new_user.password = "password-secret"
          new_user.in_mission_control = true
        end
      end
    end
  end
end