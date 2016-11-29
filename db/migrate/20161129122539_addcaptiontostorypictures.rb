class Addcaptiontostorypictures < ActiveRecord::Migration
  def change
    remove_column :travel_stories, :caption
    add_column :story_pictures, :caption, :string
  end
end
