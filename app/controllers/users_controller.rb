class UsersController < ApplicationController
  include UserSuiteControl
  include ConnectionControl

  def slices
    @user = User.find(params[:id])
  end
end
