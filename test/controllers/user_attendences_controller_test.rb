require 'test_helper'

class UserAttendencesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_attendences_new_url
    assert_response :success
  end

end
