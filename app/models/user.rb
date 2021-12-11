# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :json
#  commented_notification :boolean          default(TRUE)
#  crypted_password       :string
#  email                  :string           not null
#  followed_notification  :boolean          default(TRUE)
#  liked_notification     :boolean          default(TRUE)
#  salt                   :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :active_relationships, class_name:  'Relationship',
           foreign_key: 'follower_id',
           dependent:   :destroy
  has_many :passive_relationships, class_name:  'Relationship',
           foreign_key: 'followed_id',
           dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :notifications, dependent: :destroy

  scope :random, -> (count) { all.sample(count) }

  def own?(object)
    id == object.user_id
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.destroy(post)
  end

  def like?(post)
    liked_posts.include?(post)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.destroy(other_user)
  end

  def following?(other_user)
    following_ids.include?(other_user.id)
  end

  def feed
    Post.where(user_id: following_ids << id)
  end
end
