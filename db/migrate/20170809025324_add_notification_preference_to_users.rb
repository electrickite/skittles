class AddNotificationPreferenceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notification_preference, :text
  end
end
