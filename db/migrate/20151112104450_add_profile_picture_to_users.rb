class AddProfilePictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_pictures, :string
  end
end
