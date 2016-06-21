class AddProfilePrefecturesToUser < ActiveRecord::Migration
  def change
    add_column :users, :prefectures_code, :string
    add_column :users, :profile, :text
  end
end
