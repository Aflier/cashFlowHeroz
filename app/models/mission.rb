class Mission < ApplicationRecord
  include Connectable
  belongs_to :legal_entity
  has_many :mission_users
  has_many :users, through: :mission_users
  has_many :transactions

  def suite_links
    return if sso_uuid.blank?
    response = RestClient.get "#{$sso_url}/api/v001/missions/#{sso_uuid}/slices"
    response = JSON.parse(response)
    response['slices']
  end
end
