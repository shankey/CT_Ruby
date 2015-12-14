class AddLiveToTravelStories < ActiveRecord::Migration
  def change
    add_column :travel_stories, :live, :integer
  end
end
