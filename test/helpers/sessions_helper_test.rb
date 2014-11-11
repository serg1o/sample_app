require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  test "current_user" do
    user = users(:michael)
    log_in(user) # was not in the tutorial
    remember(user)
    assert_equal user, current_user
  end
end
