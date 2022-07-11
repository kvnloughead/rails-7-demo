require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {
      name: "",
      email: "foo@invalid",
      password: "foo",
      password_confirmation: "bar"
    }}

    assert_select 'div.alert', "This form contains 4 errors."
    assert_template 'users/edit' # should render edit form again after failure
  end

  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    new_name = "New name"
    new_email = "newemail@example.com"
    patch user_path(@user), params: { user: {
      name: new_name,
      email: new_email,
      password: "",
      password_confirmation: ""
    } }

    assert_not flash.empty?
    assert_redirected_to @user

    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)  

    new_name = "New name"
    new_email = "newemail@example.com"
    patch user_path(@user), params: { user: {
      name: new_name,
      email: new_email,
      password: "",
      password_confirmation: ""
    } }

    assert_not flash.empty?
    assert_redirected_to @user

    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email    
  end
end
