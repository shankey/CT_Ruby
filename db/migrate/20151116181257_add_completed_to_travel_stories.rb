class AddCompletedToTravelStories < ActiveRecord::Migration
  def change
    add_column :travel_stories, :completed, :integer
  end
end
