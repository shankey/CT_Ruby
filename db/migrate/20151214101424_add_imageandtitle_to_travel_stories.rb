class AddImageandtitleToTravelStories < ActiveRecord::Migration
  def change
    add_column :travel_stories, :image, :string
    add_column :travel_stories, :title, :string
  end
end
