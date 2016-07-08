class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :micropost, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
      t.index [:user_id, :created_at]
      t.index [:micropost_id, :user_id], unique: true # この行を追加
    end
  end
end
