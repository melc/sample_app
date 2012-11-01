class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :sample_user

  validates :content, presence: true, length: { maximum: 140 }    
  validates :sample_user_id, presence: true  

  default_scope order: 'microposts.created_at DESC'

  def self.from_sample_users_followed_by(sample_user)
    followed_sample_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :sample_user_id"
    where("sample_user_id IN (#{followed_sample_user_ids}) OR sample_user_id = :sample_user_id", sample_user_id: sample_user.id)
  end  
end
