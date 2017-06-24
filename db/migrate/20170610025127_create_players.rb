class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.references :game, foreign_key: true, null: false
      t.references :user, foreign_key: true
      t.integer :color, null: false, default: 0

      t.timestamps
    end

    add_index :players, [:game_id, :color], unique: true
  end
end
