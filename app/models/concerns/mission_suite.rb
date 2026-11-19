module MissionSuite
  extend ActiveSupport::Concern
  included do
    def send_users_to_reception
      user_ids = []
      users.each do |user|
        user_ids << { id: user.uid }
      end
      RestClient.post("#{$sso_url}/api/v001/missions/#{sso_uuid}/add_users",
                      { users: user_ids })
    end
  end
end