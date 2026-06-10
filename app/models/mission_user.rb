class MissionUser < ApplicationRecord
  belongs_to :mission
  belongs_to :user
  enum :role, { responsible: 1, contributor: 2, observer: 3, suspended: 4 }, default: :observer

  attr_accessor :email
  def confirmed_on_sso?
    return if Rails.env.test?
    response = RestClient.get "#{ENV['SSO_PROVIDER_URL']}/api/v001/users/confirmed?email=#{user.email}"
    response = JSON.parse(response)
    response["confirmed"]
  end
end
