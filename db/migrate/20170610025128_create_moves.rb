class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.references :game, foreign_key: true, null: false
      t.references :player, foreign_key: true, null: false
      t.integer :number, default: 0, null: false, index: true
      t.string :notation, null: false

      t.timestamps
    end

    add_index :moves, [:game_id, :number], unique: true
  end
end
