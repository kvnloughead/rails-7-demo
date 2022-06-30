# Helpers are automatically available in Rails views.
# Including them in application_controller makes them available in controllers
module SessionsHelper

  # Logs in the user
  def log_in(user)
    # session method is a Rails built-in. 
    # Sessions created in this way end when the browser window is closed.
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any)
  def current_user
    if session[:user_id]
      # find_by returns nil if no matching document found
      # note that (a ||= b) is equivalent to (a = a || b)
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, otherwise false
  def logged_in?
    !current_user.nil?
  end

  # Logs out current user
  def log_out
    # Rails built-in, used here to log user out. Ensures that _all_ session
    # variables are reset upon logging out.
    reset_session
    @current_user = nil
  end
end
