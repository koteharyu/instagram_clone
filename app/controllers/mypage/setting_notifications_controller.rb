class Mypage::SettingNotificationsController < Mypage::BaseController

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(setting_params)
      redirect_to user_path(@user), success: 'updated setting notifications'
    else
      render :edit
    end
  end

  private

  def setting_params
    params.require(:user).permit(:commented_notification, :liked_notification, :followed_notification)
  end
end
