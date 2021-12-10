class UserSessionsController < ApplicationController
  def new

  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, success: 'login'
    else
      flash.now[:danger] = 'please try more'
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_path
  end

end
