class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :resource_id
      t.string :type

      t.timestamps null: false
    end
  end
end
