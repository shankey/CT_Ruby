class Addpicturetostorypicture < ActiveRecord::Migration
  def change
    remove_attachment :travel_stories, :picture
    add_attachment :story_pictures, :picture
  end
end
