class Missions::CardsController < ApplicationController
  def show
    @mission = Mission.find(params[:mission_id])
  end
end
