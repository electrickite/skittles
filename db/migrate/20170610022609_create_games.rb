class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :result, default: 0, null: false
      t.datetime :completed_at

      t.timestamps
    end
    add_index :games, :result
  end
end
