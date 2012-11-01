class CreateSampleUsers < ActiveRecord::Migration
  def change
    create_table :sample_users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
