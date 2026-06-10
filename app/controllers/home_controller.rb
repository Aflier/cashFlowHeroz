class HomeController < ApplicationController
  def index
    @missions = Mission.all

    if current_user.missions.size == 1
      redirect_to current_user.missions.first
    end
  end
end
