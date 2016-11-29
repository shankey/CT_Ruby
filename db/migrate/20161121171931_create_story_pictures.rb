class CreateStoryPictures < ActiveRecord::Migration
  def change
    create_table :story_pictures do |t|
      t.integer :travel_story_id
      t.string :url

      t.timestamps null: false
    end
  end
end
