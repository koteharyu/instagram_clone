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
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
