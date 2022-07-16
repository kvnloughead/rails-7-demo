class UsersController < ApplicationController
  before_action :require_login, only: [:index, :edit, :update, :destroy]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: :destroy

  # Shows all users.
  def index 
    # paginate serves up chunks of users rather than the whole bunch
    @users = User.paginate(page: params[:page])
  end

  # Shows new user form view.
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

  # Updates user with data from edit view form. 
  def update 
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"      
      redirect_to @user # @user is interpreted as user_url(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # Destroys user. Prompts for confirmation first (see _users partial).
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  private
    # Creates secure hash of "strong parameters" to prevent mass assignment
    # vulnerability. Note that we don't include the :admin field in the list
    # of permitted attributes. This prevents users from granting themselves
    # unauthorized permissions.
    def user_params
      params.require(:user).permit(:name, :email, :password,            
                                   :password_confirmation)
    end

    # Before filter. Prevents users from performing action if not logged in.
    def require_login
      unless logged_in?
        store_location # store requested URL for later use
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end

    # Before filter. Prevents user from performing action on other users.
    def require_correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You can only edit your own profile."
        redirect_to(root_url, status: :see_other)
      end
    end

    # Before filter. Prevents user from performing action if not admin. 
    def require_admin
      unless current_user.admin?
        flash[:danger] = "You are not authorized to perform this action."
        redirect_to(root_url, status: :see_other)
      end
    end
end
