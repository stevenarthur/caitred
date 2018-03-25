class AddSlugToPostcode < ActiveRecord::Migration
  def change
    add_column :postcodes, :slug, :string, unique: true
  end
end
