require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin_user)
    @non_admin = users(:test_user)
  end

  test "index as admin with pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "ul.pagination", count: 2
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end
  end

  test "admin user can delete other user" do
    log_in_as(@admin)
    get users_path
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  
  test "index as non-admin has pagination but no delete links" do
    log_in_as(@non_admin)
    get users_path
    assert_template "users/index"
    assert_select "ul.pagination", count: 2
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
    assert_select 'a', text: 'delete', count: 0
  end
end
