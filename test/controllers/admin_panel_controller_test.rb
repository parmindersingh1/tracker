require 'test_helper'

class AdminPanelControllerTest < ActionController::TestCase
  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get roles" do
    get :roles
    assert_response :success
  end

end
