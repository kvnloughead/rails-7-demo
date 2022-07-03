# Helpers are automatically available in Rails views.
# Including them in application_controller makes them available in controllers
module SessionsHelper

  # Logs in the user
  def log_in(user)
    # session method is a Rails built-in. 
    # Sessions created in this way end when the browser window is closed.
    session[:user_id] = user.id
  end

  # Remembers current user in a persistent session. 
  # Called when creating a new session.
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged in user.
  def current_user
    # If there's a session with a user_id property, assign it to user_id
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      # if user exists and token from the cookie matches user.remember_digest
      if user && user.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, otherwise false
  def logged_in?
    !current_user.nil?
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
