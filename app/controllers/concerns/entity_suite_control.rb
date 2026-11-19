module EntitySuiteControl
  extend ActiveSupport::Concern
  def send_users_to_reception
    @legal_entity.send_users_to_reception
    redirect_to legal_entity_path(@legal_entity)
  end
end
