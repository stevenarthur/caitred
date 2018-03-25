class AddPasswordResetToken < ActiveRecord::Migration
  def change
    add_column :customers, :password_reset_token, :string
    add_column :customers, :reset_token_created, :datetime
  end
end
