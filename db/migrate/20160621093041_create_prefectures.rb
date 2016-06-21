class CreatePrefectures < ActiveRecord::Migration
  def change
    create_table :prefectures do |t|
      t.string :id
      t.string :name

      t.timestamps null: false
      
      t.index :id, unique: true
    end
  end
end
