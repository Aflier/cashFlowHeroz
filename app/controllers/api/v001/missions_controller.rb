class Api::V001::MissionsController < Api::V001::BaseController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access only: %i[ create ]

  def create
    legal_entity = LegalEntity.find_or_create_by(sso_uuid: params[:legal_entity_id]) do |new_legal_entity|
      new_legal_entity.name = params[:legal_entity][:name]
    end

    mission = legal_entity.missions.create(mission_params)
    if mission
      user = User.find_or_create_by!(email: params[:user][:email]) do |user|
        user.password = 'password-secret'
      end
      legal_entity.entity_users.find_or_create_by(user: user, role: :responsible)
      mission.mission_users.find_or_create_by(user: user, role: :responsible)
      mission.reload
      render json: { uuid: mission.uuid, name: mission.name, legal_entity_uuid: legal_entity.uuid, site_origin: "RH" }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  private

  def mission_params
    params.require(:mission).permit(:name, :sso_uuid)
  end
end
