class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :company
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
