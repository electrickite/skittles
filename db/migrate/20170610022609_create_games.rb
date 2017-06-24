class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.references :owner, foreign_key: { to_table: :users }
      t.integer :result, default: 0, null: false, index: true
      t.datetime :completed_at

      t.timestamps
    end
  end
end
