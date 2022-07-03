class SessionsController < ApplicationController
  def new
  end

  def create
    # params comes from login form submission
    user = User.find_by(email: params[:session][:email].downcase)
    
    # `user&.foo` is equivalent to `user && user.foo`
    if user&.authenticate(params[:session][:password])
      # Rails built-in, used here to protect against session fixation.
      reset_session

      # Remembers user in a persistent session, by:
      # - calling user.remember to create the relevant rememeber_token and #    
      #   remember_digest attributes 
      # - saving encrypted user id to a cookie
      # - saving remember_token to cookie
      # See definition in session_helper. 
      remember user
      
      log_in user      # defined in session_helper
      redirect_to user # user is converted to user_url(user)
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
    log_out
    redirect_to root_url, status: :see_other # 303 is returned on DELETE
  end
end
