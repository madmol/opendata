require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organizations_index_url
    assert_response :success
  end

  test "should get show" do
    get organizations_show_url
    assert_response :success
  end

  test "should get destroy" do
    get organizations_destroy_url
    assert_response :success
  end

end
