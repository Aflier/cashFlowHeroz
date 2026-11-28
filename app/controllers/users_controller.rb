class UsersController < ApplicationController
  include UserSuiteControl
  include ConnectionControl

  before_action :set_user, only: %i[slices suite_links]

  private

  def set_user
    @user = User.find(params.expect(:id))
  end
end
