class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions, id: false, primary_key: :jti do |t|
      t.references :account, null: false, foreign_key: true
      t.string :jti, null: false
      t.index :jti, unique: true
      t.timestamps
    end
  end
end
