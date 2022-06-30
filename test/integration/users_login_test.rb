require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @invalid_user = {
      email: "bad@email.com",
      password: "asdfasdf"
    }

    @user = users(:test_user)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity 
    assert_template 'sessions/new'
    assert_not flash.empty?
    
    # flash is gone after rendering a different endpoint
    get root_path
    assert flash.empty?
  end

  test "login with valid email / invalid password" do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: @user.email, password: "invalid" } }
    
    assert_not_equal @user.id, session[:user_id]
    assert_response :unprocessable_entity 
    assert_template 'sessions/new'
    assert_not flash.empty?
    
    # flash is gone after rendering a different endpoint
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do

    post login_path, params: { session: { email: @user.email, 
                                          password: "password" } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # Checks that user's id is the id that's stored in the session
    # Alternative to the is_logged_in? handler from Learn Enough 
    # https://www.learnenough.com/ruby-on-rails-7th-edition-tutorial/basic_login#code-test_helper_session
    assert_equal @user.id, session[:user_id]

    delete logout_path
    assert_not_equal @user.id, session[:user_id]
    assert_response :see_other
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
