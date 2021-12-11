class ApplicationController < ActionController::Base
  before_action :set_search_posts_form
  add_flash_types :success, :info, :warning, :danger

  private

  def not_authenticated
    redirect_to login_path, danger: "please login"
  end

  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_posts_params)
  end

  def search_posts_params
    params.fetch(:q, {}).permit(:post_body, :comment_body, :username)
  end
end
