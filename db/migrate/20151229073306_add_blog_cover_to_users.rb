class AddBlogCoverToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blog_cover_image, :string
  end
end
