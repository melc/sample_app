class AddPasswordDigestToSampleUsers < ActiveRecord::Migration
  def change
    add_column :sample_users, :password_digest, :string
  end
end
