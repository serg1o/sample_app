require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @user2 = users(:lana)
    @user2.update_attribute(:activated, false)
  end

  test "does not show inactive user profile" do    
    log_in_as(@user)
    get user_path(@user2)
    assert_redirected_to root_url
  end

  test "does not show inactive user in list of users" do    
    log_in_as(@user)
    get users_path
    assert_select "a[href=?]", user_path(@user2), count: 0
  end
end
