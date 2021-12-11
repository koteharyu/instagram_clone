# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  notifiable_type :string           not null
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_notifications_on_notifiable  (notifiable_type,notifiable_id)
#  index_notifications_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :recent, -> (count) { order(created_at: :desc).limit(count) }

  enum read: { unread: false, read: true }

  def call_appropriate_partial
    case self.notifiable_type
    when 'Comment'
      'commented_to_own_post'
    when 'Like'
      'liked_to_own_post'
    when 'Relationship'
      'followed_me'
    end
  end
end
