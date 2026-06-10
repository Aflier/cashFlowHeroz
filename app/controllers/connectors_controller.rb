class ConnectorsController < ApplicationController
  # GET /connectors or /connectors.json
  def index
    @user = current_user
  end
end
