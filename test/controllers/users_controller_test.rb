require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @other_user = users(:other_user)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test 'should redirect on edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect on update when not logged in' do
    patch user_path(@user), params: { user: { name: "New name", 
                                              email: "newemail@mail.com" }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect on edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect on update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: "New name", 
                                              email: "newemail@mail.com" }}
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect user index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'admin attribute is not editable via PATCH' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { 
                                      password: "password",     
                                      password_confirmation: "password",
                                      admin: true }}
    assert_not @other_user.admin?
  end
end
