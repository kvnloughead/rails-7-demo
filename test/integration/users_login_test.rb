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
    assert_response :unprocessable_entity 
    assert_template 'sessions/new'
    assert_not flash.empty?
    
    # flash is gone after rendering a different endpoint
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do

    post login_path, params: { session: { email: @user.email, 
                                          password: "password" } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # assert_template 'sessions/new'
    # assert_not flash.empty?
    
    # flash is gone after rendering a different endpoint
    # get root_path
    # assert flash.empty?
  end
end
