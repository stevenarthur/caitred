class AddSpamBooleanToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :spam, :boolean, default: false
  end
end
