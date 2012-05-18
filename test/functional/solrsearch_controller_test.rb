require 'test_helper'

class SolrsearchControllerTest < ActionController::TestCase
  test "should get dosearch" do
    get :dosearch
    assert_response :success
  end

end
