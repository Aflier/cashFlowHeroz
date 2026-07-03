class UsersController < ApplicationController
  include ConnectionControl

  def slices
    @user = User.find(params[:id])
  end
end
