class AddNumberOfPeopleToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :number_of_people, :string
  end
end
