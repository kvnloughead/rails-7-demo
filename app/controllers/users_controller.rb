class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    # injects @user variable with appropriate id into the view
    # url: root_path/users?id=user-id
    @user = User.find(params[:id])
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      # success
    else
      # HTTP status 422. This is necessary in Rails 7 
      # when rendering regular HTML with Turbo
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
