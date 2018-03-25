class EnsureIsAlternativeIsFalseByDefault < ActiveRecord::Migration
  def up
    sql = <<-SQL
      update menu_packages set is_alternative = false
    SQL
    execute sql
    change_column :menu_packages, :is_alternative, :boolean, null: false, default: false
  end

  def down

  end
end
