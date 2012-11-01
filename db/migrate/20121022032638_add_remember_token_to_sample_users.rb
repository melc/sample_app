class AddRememberTokenToSampleUsers < ActiveRecord::Migration
  def change
    add_column :sample_users, :remember_token, :string
    add_index  :sample_users, :remember_token  	
  end
end
