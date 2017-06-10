class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.references :game, foreign_key: true
      t.integer :number
      t.integer :color
      t.integer :piece
      t.string :departure
      t.string :destination
      t.boolean :capture
      t.integer :castle
      t.integer :promotion
      t.boolean :check
      t.boolean :mate

      t.timestamps
    end
  end
end
