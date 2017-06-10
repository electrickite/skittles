class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.references :game, foreign_key: true
      t.integer :number, default: 0, null: false
      t.integer :color, default: 0, null: false
      t.integer :piece, default: 0, null: false
      t.string :departure, null: false
      t.string :destination, null: false
      t.boolean :capture
      t.integer :castle
      t.integer :promotion
      t.boolean :check
      t.boolean :mate

      t.timestamps
    end
    add_index :moves, [:game_id, :number], unique: true
  end
end
