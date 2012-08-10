require 'test_helper'

class PassesControllerTest < ActionController::TestCase
  setup do
    @pass = passes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:passes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pass" do
    assert_difference('Pass.count') do
      post :create, pass: { description: @pass.description, organization_name: @pass.organization_name, pass_type_identifier: @pass.pass_type_identifier, team_identifier: @pass.team_identifier }
    end

    assert_redirected_to pass_path(assigns(:pass))
  end

  test "should show pass" do
    get :show, id: @pass
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pass
    assert_response :success
  end

  test "should update pass" do
    put :update, id: @pass, pass: { description: @pass.description, organization_name: @pass.organization_name, pass_type_identifier: @pass.pass_type_identifier, team_identifier: @pass.team_identifier }
    assert_redirected_to pass_path(assigns(:pass))
  end

  test "should destroy pass" do
    assert_difference('Pass.count', -1) do
      delete :destroy, id: @pass
    end

    assert_redirected_to passes_path
  end
end
