require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @invalid_user = {
      email: "bad@email.com",
      password: "asdfasdf"
    }
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
end
