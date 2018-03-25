class AddConfirmationTokenToOrder < ActiveRecord::Migration
  def change
    add_column :enquiries, :confirmation_token, :string
    add_column :enquiries, :confirmation_token_created, :datetime
  end
end
