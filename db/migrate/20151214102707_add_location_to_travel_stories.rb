class AddLocationToTravelStories < ActiveRecord::Migration
  def change
    add_column :travel_stories, :location, :string
  end
end
