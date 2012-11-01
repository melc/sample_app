class AddIndexToSampleUsersEmail < ActiveRecord::Migration
  def change
  	add_index :sample_users, :email, unique: true
 
  end
end
