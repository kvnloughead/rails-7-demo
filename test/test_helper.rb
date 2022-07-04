ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Improve test output
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
  
  # Returns true if the user is logged in.
  def is_logged_in?
    @user.id == session[:user_id]
  end

  # Log in as a particular user.
  #
  # @param user [User] a User instance
  # @note For integration tests, use the IntegrationTest method instead 
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # Log in as a particular user.
  #
  # @param user [User] a User instance
  # @param password [String] password to use when logging in
  # @param remember_me ['0', '1'] whether the rememeber me option is selected
  #   '0' means 'forget user'. '1' means 'remember user'
  # @note Outside integration tests, use the TestCase method instead
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email, 
                                          password: password,
                                          remember_me: remember_me }}
  end
end
