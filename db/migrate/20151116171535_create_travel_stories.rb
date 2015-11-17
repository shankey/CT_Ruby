class CreateTravelStories < ActiveRecord::Migration
  def change
    create_table :travel_stories do |t|
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
