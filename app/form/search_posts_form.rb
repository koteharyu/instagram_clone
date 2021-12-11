class SearchPostsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :post_body, :string
  attribute :comment_body, :string
  attribute :username, :string

  def search
    posts = Post.all
    posts = posts.post_body_contain(post_body) if post_body.present?
    posts = posts.comment_body_contain(comment_body) if comment_body.present?
    posts = posts.username_contain(username) if username.present?
    posts
  end
end
