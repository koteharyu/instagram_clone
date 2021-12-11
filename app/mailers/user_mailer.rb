class UserMailer < ApplicationMailer

  def comment_post
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @comment = params[:comment]
    mail(to: @user_to.email, subject: "#{@user_from.username} commented to your post")
  end

  def like_post
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @post = params[:post]
    mail(to: @user_to.email, subject: "#{@user_from.username} liked your post")
  end

  def follow
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    mail(to: @user_to.email, subject: "#{@user_from.username} followed you")
  end
end
