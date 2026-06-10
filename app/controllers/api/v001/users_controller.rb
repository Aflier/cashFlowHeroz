class Api::V001::UsersController < Api::V001::BaseController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access only: %i[ add_connection refresh_connection remove_connector ]

  def add_connection
    user = User.find_by(uid: params[:id])
    return unless user

    user.set_filter(:finish_id, nil)
    user.set_filter(:finish_type, nil)
    user.set_filter(:start_id, nil)
    user.set_filter(:start_type, nil)
    user.update_connector
    if params[:connector][:fromable_type].present? and params[:connector][:fromable_uuid].present? &&
       User::CONNECTORS_TO_REFRESH.include?(params[:connector][:fromable_type])
      fromable_instance = Object.const_get(params[:connector][:fromable_type]).find_by(uuid: params[:connector][:fromable_uuid])
      user.update_node(fromable_instance) if fromable_instance
    end

    if params[:connector][:toable_type].present? and params[:connector][:toable_uuid].present? &&
       User::CONNECTORS_TO_REFRESH.include?(params[:connector][:toable_type])
      toable_instance = Object.const_get(params[:connector][:toable_type]).find_by(uuid: params[:connector][:toable_uuid])
      user.update_node(toable_instance) if toable_instance
    end
    render json: { status: :ok }
  end

  def refresh_connection
    user = User.find_by(uid: params[:id])
    return unless user

    user.set_filter(:finish_id, params[:fromable])
    user.set_filter(:finish_type, params[:fromable])
    user.set_filter(:toable_id, params[:toable])
    user.set_filter(:toable_type, params[:toable])
    user.update_connector
    render json: { status: :ok }
  end

  def remove_connector
    user = User.find_by_uid(params[:id])
    return unless user

    if params[:connector_type].present? and params[:connector_uuid].present? && User::CONNECTORS_TO_REFRESH.include?(params[:connector_type])
      connector_instance = Object.const_get(params[:connector_type]).find_by(uuid: params[:connector_uuid])
      user.update_node(connector_instance) if connector_instance
    end
    render json: { status: :ok }
  end
end
