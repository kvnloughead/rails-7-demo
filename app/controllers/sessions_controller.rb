# Sessions are not persistent by default, so user will not be remembered unless
# the remember me box is checked when logging in. However, in my experience
# users will still be remembered unless you uncheck the browser option to 
# continue running background apps when the browser is closed.

class SessionsController < ApplicationController
  def new
  end

  def create
    # Creating an @variable in Controller.create allows you to access
    # the instance inside tests using assigns(:variable).
    @user = User.find_by(email: params[:session][:email].downcase)
    
    # `user&.foo` is equivalent to `user && user.foo`
    if @user&.authenticate(params[:session][:password])
      # Rails built-in, used here to protect against session fixation.
      reset_session
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)

      log_in @user      # defined in session_helper
      redirect_to @user # user is converted to user_url(user)

    else
      # The flash hash will be available in the templates. The :danger key is 
      # conventional, but arbitrary. See application.html.erb for the markup.
      # flash.now disappears whenever a new request is made
      flash.now[:danger] = "Invalid email/password combination"
      render 'new', status: :unprocessable_entity
    end
  end

  # Logs out current user.
  def destroy
    # Only log out when logged in to prevent an undefined user bug when logged 
    # in in multiple browser tabs.
    log_out if logged_in?
    redirect_to root_url, status: :see_other # 303 is returned on DELETE
  end
end
