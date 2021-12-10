class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, success: 'create a user'
    else
      flash.now[:danger] = 'mistake'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
