class AddMenuTitleToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :menu_title, :string
  end
end
