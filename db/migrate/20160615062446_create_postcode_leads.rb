class CreatePostcodeLeads < ActiveRecord::Migration
  def change
    create_table :postcode_leads do |t|
      t.string :email, null: false
      t.string :postcode, null: false

      t.timestamps null: false
    end
  end
end
