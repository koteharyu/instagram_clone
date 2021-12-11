class Mypage::AccountsController < Mypage::BaseController

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(account_params)
      redirect_to user_path(@user), success: 'update'
    else
      render :edit
    end
  end

  private

  def account_params
    params.require(:user).permit(:username, :avatar, :avatar_cache)
  end
end
