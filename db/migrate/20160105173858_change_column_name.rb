class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :collections, :type, :collection_type
  end
end
