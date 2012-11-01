class AddPasswordToSampleUsers < ActiveRecord::Migration
  def change
    add_column :sample_users, :password, :string
  end
end
