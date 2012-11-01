class AddPasswordConfirmationToSampleUsers < ActiveRecord::Migration
  def change
    add_column :sample_users, :password_confirmation, :string
  end
end
