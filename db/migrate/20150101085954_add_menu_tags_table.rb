class AddMenuTagsTable < ActiveRecord::Migration
  def change
    create_table :menu_tags do |t|
      t.string :tag
      t.string :badge_url
      t.boolean :is_filter
      t.timestamps
    end
  end
end
