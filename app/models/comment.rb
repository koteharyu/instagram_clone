# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_create_commit :create_notification

  validates :body, presence: true, length: { maximum: 500 }

  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  def partial_name
    'commented_to_own_post'
  end

  def redirect_path
    post_path(post, anchor: "comment-#{id}}")
  end

  private

  def create_notification
    Notification.create(notifiable: self, user: post.user)
  end
end
