class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :year
      t.integer :artist_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
