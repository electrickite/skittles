class AddPhoneToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :phone, :string
    add_index :users, :phone
  end
end
