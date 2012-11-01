class AddAdminToSampleUsers < ActiveRecord::Migration
  def change
    add_column :sample_users, :admin, :boolean, default: false
  end
end
