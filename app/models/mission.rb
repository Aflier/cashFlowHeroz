class Mission < ApplicationRecord
  include MissionSuite
  include Connectable
  belongs_to :legal_entity
  has_many :mission_users
  has_many :users, through: :mission_users
  has_many :transactions
  has_many :banks
  has_many :creditors

  # def suite_links
  #   return if sso_uuid.blank?
  #   response = RestClient.get "#{$sso_url}/api/v001/missions/#{sso_uuid}/slices"
  #   response = JSON.parse(response)
  #   response['slices']
  # end


  def starting_balance
    banks.sum(:current_balance)
  end
end
