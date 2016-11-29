class Addcolumncaptiontostories < ActiveRecord::Migration
  def change
    add_column :travel_stories, :caption, :string
  end
end
