class LegalEntitiesController < ApplicationController
  before_action :set_legal_entity, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  def index
    @legal_entities = current_user.legal_entities
  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def set_legal_entity
    @legal_entity = LegalEntity.find(params[:id])
  end
end
