module MissionSuiteControl
  extend ActiveSupport::Concern

  def send_users_to_reception
    @mission.send_users_to_reception
    redirect_to mission_path(@mission)
  end
end
