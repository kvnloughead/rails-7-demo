require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @paths = [ 
      { name: root_path,             count: 2, appears_when: { logged_in: true,  not_logged_in: true  }, title: "" }, 
      { name: help_path,             count: 1, appears_when: { logged_in: true,  not_logged_in: true  }, title: "Help" }, 
      { name: about_path,            count: 1, appears_when: { logged_in: true,  not_logged_in: true  }, title: "About" }, 
      { name: contact_path,          count: 1, appears_when: { logged_in: true,  not_logged_in: true  }, title: "Contact" }, 
      { name: signup_path,           count: 1, appears_when: { logged_in: true,  not_logged_in: true  }, title: "Sign up" }, 
      { name: login_path,            count: 1, appears_when: { logged_in: false, not_logged_in: true  }, title: "Log in" }, 
      { name: users_path,            count: 1, appears_when: { logged_in: true,  not_logged_in: false }, title: "All users" }, 
      { name: user_path(@user),      count: 1, appears_when: { logged_in: true,  not_logged_in: false }, title: @user.name }, 
      { name: edit_user_path(@user), count: 1, appears_when: { logged_in: true,  not_logged_in: false }, title: "Edit user" }, 
  ]
  end
  
  test "when not logged in, layout links serve correct pages" do
    get root_path
    assert_template 'static_pages/home'

    @paths.each do |path|
      if path[:appears_when][:not_logged_in]
        get root_path # without this line in each block, test fails on /signup
        assert_select "a[href=?]", path[:name], count: path[:count]
        get path[:name]
        assert_select "title", full_title(path[:title])
      else
        assert_select "a[href=?]", path[:name], false, 
                      "Link to #{path[:name]} should not appear unless logged in"
      end
    end  
  end
    
  test "when logged in, layout links serve correct pages" do
    get root_path
    assert_template 'static_pages/home'

    @paths.each do |path|
      log_in_as(@user) # else block won't work correctly without this in the loop
      if path[:appears_when][:logged_in]
        get root_path # without this line in each block, test fails on /signup
        assert_select "a[href=?]", path[:name], count: path[:count]
        get path[:name]
        assert_select "title", full_title(path[:title])
      else
        assert_select "a[href=?]", path[:name], false,
                      "Link to #{path[:name]} should not appear when logged in"            
      end
    end  
  end
  
end
