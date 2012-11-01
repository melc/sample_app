class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :sample_user_id

      t.timestamps
    end
    add_index :microposts, [:sample_user_id, :created_at]    
  end
end
