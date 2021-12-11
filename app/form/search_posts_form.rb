class SearchPostsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :body, :string

  def search
    posts = Post.all
    posts = posts.body_contain(body) if body.present?
    posts
  end
end
