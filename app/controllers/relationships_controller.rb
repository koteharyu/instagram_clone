class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    # @user = Relationship.find_by(follower_id: current_user.id, followed_id: params[:user_id])
    current_user.unfollow(@user)
  end
end
