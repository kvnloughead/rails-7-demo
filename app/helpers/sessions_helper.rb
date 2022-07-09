# Helpers are automatically available in Rails views.
# Including them in application_controller makes them available in controllers
module SessionsHelper

  # Logs in the supplied user.
  #
  # @param user [User] the User instance to be logged in
  def log_in(user)
    session[:user_id] = user.id
    # Used to guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:session_token] = user.session_token
  end

  # Remembers current user.
  #
  # @param user [User] the User instance to be remembered
  def remember(user)
    user.remember # Creates remember_token and remember_digest the for user
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # @return [User] the currently logged in user.
  def current_user
    # If there's a session with a user_id property, assign it to user_id
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      # Guard against session replay attacks.
      if user && session[:session_token] == user.session_token
        @current_user = user
      end

    # Else if there's a cookie with a user_id property, assign it to user_id
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      
      # if user exists and token from the cookie matches user.remember_digest
      if user&.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
      end
    end
  end

  # @return [Boolean] whether the user is logged in
  def logged_in?
    !current_user.nil?
  end

  # @return [Boolean] whether the given user is the current user
  def current_user?(user)
    user && user == @current_user
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget # set remember_digest to nil
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out current user
  def log_out
    forget(current_user)

    # Rails built-in, used here to log user out. Ensures that _all_ session
    # variables are reset upon logging out.
    reset_session
    @current_user = nil
  end
end
