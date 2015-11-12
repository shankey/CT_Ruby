class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :external_id
      t.string :access_token
      t.string :name
      t.string :email

      t.timestamps null: false
    end
  end
end
