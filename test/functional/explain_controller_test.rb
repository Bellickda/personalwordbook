require 'test_helper'

class ExplainControllerTest < ActionController::TestCase
  test "should get explain" do
    get :explain
    assert_response :success
  end

end
