class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    # Injects @user variable with appropriate id into the view
    #  - url: root_path/users?id=user-id
    @user = User.find(params[:id])
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      # The flash hash will be available in the templates. The :success key is # conventional, but arbitrary. See application.html.erb for the markup.
      flash[:success] = "You've successfully registered!"
      # Rails infers this to mean `redirect_to user_url(@user)` 
      redirect_to @user 
    else
      render 'new', status: :unprocessable_entity 
    end
  end

  private
    # Create secure hash of parameters for User model
    def user_params
      params.require(:user).permit(:name, :email, :password,            
                                   :password_confirmation)
    end
end
