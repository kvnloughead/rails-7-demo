require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @user_data = { name: "Example User", 
                   email: "example@example.com", 
                   password: "password", 
                   password_confirmation: "password"}
    @no_name = { **@user_data, name: "" }
    @bad_email = { **@user_data, email: "foo@bar" }
    @short_pwd = { **@user_data, password: "pass" }
    @not_matching_pwds = { **@user_data, password: "password", 
                           password_confirmation: "pwd" }

    @first_error_selector = "div.error_explanation .alert ul li"
  end

  test "user not created on invalid form submission" do
    get signup_path
    assert_no_difference 'User.count' do # number of users won't change
      post users_path, params: { user: @no_name }
      assert_select @first_error_selector, "Name can't be blank"

      post users_path, params: { user: @bad_email }
      assert_select @first_error_selector, "Email is invalid"

      post users_path, params: { user: @short_pwd }
      assert_select @first_error_selector, "Password is too short (minimum is 6 characters)"

      post users_path, params: { user: @not_matching_pwds }
      assert_select @first_error_selector, "Password confirmation doesn't match Password"

    end

    assert_response :unprocessable_entity # status code 422
    assert_template 'users/new'
  end

  test "user created on valid form submission" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: @user_data } 
    end
    # Go where redirected and make sure correct template is rendered
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
