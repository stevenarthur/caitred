class AddIndexOnRegisteredAndEmail < ActiveRecord::Migration
  def change
    add_index :customers, [:email, :created_account]
  end
end
