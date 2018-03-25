class AddNumberOfAttendeesToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :number_of_attendees, :integer
  end
end
