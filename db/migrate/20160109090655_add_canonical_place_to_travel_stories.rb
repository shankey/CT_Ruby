class AddCanonicalPlaceToTravelStories < ActiveRecord::Migration
  def change
    add_column :travel_stories, :canonical_location, :string
  end
end
