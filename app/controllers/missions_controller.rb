class MissionsController < ApplicationController
  include ConnectableControl
  before_action :set_mission, only: %i[ show edit connectors update ]
  load_and_authorize_resource

  def index
    @missions = current_user.missions
  end

  def show
    @transactions = @mission.transactions.ordered.page(params[:page])
  end

  def edit
  end

  def update
    @mission.update(mission_params)

    redirect_to @mission
  end

  private
  def set_mission
    @connectable = @mission = Mission.find(params[:id])
  end


  def mission_params
    params.expect(mission: [ :tenant_id, :xero_webhook_key  ])
  end
end
