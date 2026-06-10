require "test_helper"

class LegalEntitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @legal_entity = legal_entities(:one)
  end

  test "should get index" do
    get legal_entities_url
    assert_response :success
  end

  test "should get new" do
    get new_legal_entity_url
    assert_response :success
  end

  test "should create legal_entity" do
    assert_difference("LegalEntity.count") do
      post legal_entities_url, params: { legal_entity: { name: @legal_entity.name, sso_uuid: @legal_entity.sso_uuid } }
    end

    assert_redirected_to legal_entity_url(LegalEntity.last)
  end

  test "should show legal_entity" do
    get legal_entity_url(@legal_entity)
    assert_response :success
  end

  test "should get edit" do
    get edit_legal_entity_url(@legal_entity)
    assert_response :success
  end

  test "should update legal_entity" do
    patch legal_entity_url(@legal_entity), params: { legal_entity: { name: @legal_entity.name, sso_uuid: @legal_entity.sso_uuid } }
    assert_redirected_to legal_entity_url(@legal_entity)
  end

  test "should destroy legal_entity" do
    assert_difference("LegalEntity.count", -1) do
      delete legal_entity_url(@legal_entity)
    end

    assert_redirected_to legal_entities_url
  end
end
