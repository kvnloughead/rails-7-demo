class UsersController < ApplicationController
  def new
    @user = User.new
  end

  # Shows view in users/show.html.erb at users/:id.
  def show
    @user = User.find(params[:id])
  end

  # Creates new user from form data. 
  def create 
    @user = User.new(user_params)
    if @user.save
      # Rails built-in, used here to protect against session fixation.
      reset_session
      log_in @user
      
      # The flash hash will be available in the templates. The :success key is # conventional, but arbitrary. See application.html.erb for the markup.
      flash[:success] = "You've successfully registered!"
      # Rails infers this to mean `redirect_to user_url(@user)` 
      redirect_to @user 
    else
      render 'new', status: :unprocessable_entity 
    end
  end

  # Shows view in users/edit.html.erb at users/:id/edit.
  def edit
    @user = User.find(params[:id])
  end

  private
    # Create secure hash of parameters for User model
    def user_params
      params.require(:user).permit(:name, :email, :password,            
                                   :password_confirmation)
    end
end
