require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest
  def setup
    # Test user found in users.yml
    @user = users(:test_user)
  end 

  class InvalidPasswordTest < UsersLogin
    
    test "login path" do
      get login_path
      assert_template 'sessions/new'
    end

    test "login with valid email/invalid password" do
      post login_path, params: { session: { email: @user.email, password: "" } }
      assert_response :unprocessable_entity 
      assert_template 'sessions/new'
      assert_not flash.empty?
      
      # flash is gone after rendering a different endpoint
      get root_path
      assert flash.empty?
    end

    test "login with completely invalid information" do
      post login_path, params: { session: { email: "", password: "" } }
      assert_response :unprocessable_entity 
      assert_template 'sessions/new'
      assert_not flash.empty?
      
      # flash is gone after rendering a different endpoint
      get root_path
      assert flash.empty?
    end
  end

  class ValidLogin < UsersLogin
    def setup
      super
      post login_path, params: { session: { email: @user.email, password: "password" } }
    end
  end

  class ValidLoginTest < ValidLogin
    test "valid login" do
      assert is_logged_in?
      assert_redirected_to @user
    end

    test "redirect after login" do
      follow_redirect!
      assert_template 'users/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(@user)
    end

    class Logout < ValidLogin
      def setup
        super
        delete logout_path
      end

      test "successful logout" do
        assert_not is_logged_in?
        assert_response :see_other
        assert_redirected_to root_url
      end

      test "redirect after logout" do
        follow_redirect!
        assert_select "a[href=?]", login_path
        assert_select "a[href=?]", logout_path,      count: 0
        assert_select "a[href=?]", user_path(@user), count: 0
      end

      test "should still work after logout in second window" do
        delete logout_path
        assert_redirected_to root_url
      end
    end
  end

  class RememberingTest < UsersLogin
    test "login with remembering" do
      log_in_as(@user, remember_me: '1')
      # Check that user's remember_token matches the one in cookies.
      # @note assigns(:user) accesses @user from SessionController.create
      assert_equal cookies[:remember_token], assigns(:user).remember_token
    end

    test "login without remembering" do
      log_in_as(@user, remember_me: '1') # Log in to set the cookie
      log_in_as(@user, remember_me: '0') # Log in again to delete cookie
      assert cookies[:remember_me].blank? # # Must be "" or nil
    end
  end
end