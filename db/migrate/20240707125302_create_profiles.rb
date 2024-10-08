class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.text :name
      t.string :description
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
