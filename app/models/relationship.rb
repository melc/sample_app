class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name: "SampleUser"
  belongs_to :followed, class_name: "SampleUser"  

  validates :follower_id, presence: true
  validates :followed_id, presence: true  
end
