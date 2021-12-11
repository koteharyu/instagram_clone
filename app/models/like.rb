# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_post_id_and_user_id  (post_id,user_id) UNIQUE
#  index_likes_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_create_commit :create_notification

  validates :user_id, uniqueness: { scope: :post_id }

  belongs_to :post
  belongs_to :user
  has_one :notification, as: :notifiable, dependent: :destroy

  def partial_name
    'liked_to_own_post'
  end

  def redirect_path
    post_path(post)
  end

  private

  def create_notification
    Notification.create(notifiable: self, user: post.user)
  end
end
