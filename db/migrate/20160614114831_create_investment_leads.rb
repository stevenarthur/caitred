class CreateInvestmentLeads < ActiveRecord::Migration
  def change
    create_table :investment_leads do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :location
      t.boolean :invested_in_a_startup_previously, null: false
      t.string :typical_investment_size

      t.timestamps null: false
    end
  end
end
