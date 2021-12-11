class AddNotificationFlagToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :commented_notification, :boolean, default: true
    add_column :users, :liked_notification, :boolean, default: true
    add_column :users, :followed_notification, :boolean, default: true
  end
end
