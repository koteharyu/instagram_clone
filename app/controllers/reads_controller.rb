class ReadsController < ApplicationController
  before_action :require_login, only: %i[update]

  def update
    @notification = current_user.notifications.find(params[:notification_id])
    if @notification.unread?
      @notification.read!
      redirect_to @notification.appropriate_path
    end
  end
end
