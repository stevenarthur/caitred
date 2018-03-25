class UpdateEmailTextToText < ActiveRecord::Migration
  def change
    change_column :supplier_communications, :email_text, :text
  end
end
