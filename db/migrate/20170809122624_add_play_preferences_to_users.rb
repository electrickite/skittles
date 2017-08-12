class AddPlayPreferencesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :play_methods, :text
    add_column :users, :play_token, :string
  end
end
