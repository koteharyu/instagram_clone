class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save && @comment.post.user.commented_notification?
      UserMailer.with(user_from: current_user, user_to: @comment.post.user, comment: @comment).comment_post.deliver_later
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(update_comment_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def update_comment_params
    params.require(:comment).permit(:body)
  end
end
