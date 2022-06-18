class SessionsController < ApplicationController
  def new
  end

  def create
    # params comes from login form submission
    user = User.find_by(email: params[:session][:email].downcase)
    
    # If user exists and password matches
    if user && user.authenticate(params[:session][:password])
      # Log in user and redirect to users/:id
    else
      # The flash hash will be available in the templates. The :danger key is 
      # conventional, but arbitrary. See application.html.erb for the markup.
      # flash.now disappears whenever a new request is made
      flash.now[:danger] = "Invalid email/password combination"
    end
    render 'new', status: :unprocessable_entity
  end

  def destroy
  end
end
