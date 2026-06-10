class MissionUsersController < ApplicationController
  before_action :set_mission_user, only: %i[ update ]

  load_and_authorize_resource :mission, parent_action: :update, only: [:new, :create]
  load_and_authorize_resource :mission_user, through: :mission, shallow: true
  load_and_authorize_resource only: [:update, :destroy]

  def new
    @mission = Mission.find(params[:mission_id])
    @mission_user = @mission.mission_users.build
    @path = [@mission, @mission_user]
  end

  def create
    @mission = Mission.find(params[:mission_id])
    @user = User.find_by(email: params[:mission_user][:email])

    if @user.nil?
      response = RestClient.get "#{ENV['SSO_PROVIDER_URL']}/api/v001/users/new_user?email=#{params[:mission_user][:email]}&site_url=#{request.base_url}"

      payload = JSON.parse(response.body)
      auth_data = payload["auth"]

      if auth_data.is_a?(String)
        auth_data = JSON.parse(auth_data)
      end

      if auth_data.is_a?(Hash)
        auth_hash = OmniAuth::AuthHash.new(auth_data)
        @user = User.from_omniauth(auth_hash)
      end
    end
    if @user&.persisted?
      @mission_user = @mission.mission_users.find_or_create_by!(user: @user)
    end
  end

  def update
    @mission_user.update(mission_user_params)
  end

  def destroy
    @mission_user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_mission_user
    @mission_user = MissionUser.find(params[:id])
  end

  def mission_user_params
    params.expect(mission_user: [:email, :role])
  end
end