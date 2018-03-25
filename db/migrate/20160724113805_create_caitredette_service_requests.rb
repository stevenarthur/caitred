class CreateCaitredetteServiceRequests < ActiveRecord::Migration
  def change
    create_table :caitredette_service_requests do |t|
      t.string :name
      t.string :company_name
      t.string :email
      t.string :phone
      t.string :postcode
      t.string :preferred_communication_method
      t.text :message

      t.timestamps null: false
    end
  end
end
