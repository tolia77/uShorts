class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :jti

      t.timestamps
    end
  end
end
