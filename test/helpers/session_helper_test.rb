# Tests for rememeber branch of SessionHelper::current_user.
# Can't be easily tested in integration tests for reasons that escape my grasp.
#
# See https://www.learnenough.com/ruby-on-rails-7th-edition-tutorial/advanced_login#sec-testing_the_remember_branch

require "test_helper"

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:test_user)
    remember(@user)
  end

  test "current_user returns correct user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end