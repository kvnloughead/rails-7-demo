# Helpers are automatically available in Rails views.
# Including them in application_controller makes them available in controllers
module SessionsHelper

  # Logs in the user
  def log_in(user)
    # session method is a Rails built-in. 
    # Sessions created in this way end when the browser window is closed.
    session[:user_id] = user.id

  end
end
