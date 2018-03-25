class RenameCuisineOnFoodArtisanToQuickDescription < ActiveRecord::Migration
  def change
    rename_column :food_artisans, :cuisine, :quick_description
  end
end
