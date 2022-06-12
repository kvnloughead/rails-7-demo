class UsersController < ApplicationController
  def new
  end

  def show
    # injects @user variable with appropriate id into the view
    # url: root_path/users?id=user-id
    @user = User.find(params[:id])
  end
end
