class Addpicturetotravelstory < ActiveRecord::Migration
  def change
    add_attachment :travel_stories, :picture
  end
end
