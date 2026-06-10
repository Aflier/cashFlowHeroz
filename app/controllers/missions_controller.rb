class MissionsController < ApplicationController
  include ConnectableControl
  before_action :set_mission, only: %i[ show edit connectors ]
  load_and_authorize_resource

  def index
    @missions = current_user.missions
  end

  def show
  end

  def edit
  end

  private
  def set_mission
    @connectable = @mission = Mission.find(params[:id])
  end
end
