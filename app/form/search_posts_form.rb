class SearchPostsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :post_body, :string
  attribute :comment_body, :string
  attribute :username, :string

  def search
    posts = Post.all
    posts = splited_bodies.map { |splited_body| posts.post_body_contain(splited_body) }.inject { |result, scp| result.or(scp) } if post_body.present?
    posts = posts.comment_body_contain(comment_body) if comment_body.present?
    posts = posts.username_contain(username) if username.present?
    posts
  end

  private

  def splited_bodies
    post_body.strip.split(/[[:blank:]]+/)
  end
end
