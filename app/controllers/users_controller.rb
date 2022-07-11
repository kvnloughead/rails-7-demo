class UsersController < ApplicationController
  before_action :handle_unauthorized_user, only: [:edit, :update]
  before_action :handle_incorrect_user, only: [:edit, :update]

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
      reset_session # Rails built-in, protects against session fixation.
      log_in @user
      flash[:success] = "You've successfully registered!"
      redirect_to @user # @user is interpreted as user_url(@user)
    else
      render 'new', status: :unprocessable_entity 
    end
  end

  # Shows view in users/edit.html.erb at users/:id/edit.
  def edit
    @user = User.find(params[:id])
  end

  # Updates user 
  def update 
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"      
      redirect_to @user # @user is interpreted as user_url(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private
    # Creates secure hash of "strong parameters" to prevent mass assignment
    # vulnerability.
    def user_params
      params.require(:user).permit(:name, :email, :password,            
                                   :password_confirmation)
    end

    # Before filter for :edit and :update actions.
    # Prevents users from editing profiles if they are not logged in.
    def handle_unauthorized_user
      unless logged_in?
        store_location # store requested URL for later use
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end

    def handle_incorrect_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You can only edit your own profile."
        redirect_to(root_url, status: :see_other)
      end
    end
end
