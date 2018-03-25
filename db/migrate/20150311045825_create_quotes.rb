class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :message
      t.belongs_to :food_partner
      t.string :status

      t.timestamps
    end

    add_index :quotes, :food_partner_id
  end
end
