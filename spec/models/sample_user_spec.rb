# == Schema Information
#
# Table name: sample_users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe SampleUser do

  before do
  	@sample_user = SampleUser.new(name: "Example User", email: "sample_user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject {@sample_user}
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }  
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_sample_users) }  
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }    
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }  
  it { should respond_to(:unfollow!) }  

    
  it { should be_valid }

  describe "remember token" do
    before { @sample_user.save }
    its(:remember_token) { should_not be_blank }     #=it { @sample_user.remember_token.should_not be_blank }
  end

  describe "when name is not present" do
  	before { @sample_user.name = " " }
  	it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @sample_user.password = @sample_user.password_confirmation = " " }
    it { should_not be_valid }
  end  

  describe "when password doesn't match confirmation" do 
    before { @sample_user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end  

  describe "when password confirmation is nil" do
    before { @sample_user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @sample_user.save }
    let(:found_sample_user) {SampleUser.find_by_email(@sample_user.email)}

    describe "with valid password" do
      it { should == found_sample_user.authenticate(@sample_user.password)}
    end
    
    describe "with invalid password" do
      let(:sample_user_for_invalid_password) { found_sample_user.authenticate("invalid")}

      it { should_not == sample_user_for_invalid_password }
      specify { sample_user_for_invalid_password.should be_false }
    end 
  end 
  
  describe "micropost associations" do

    before { @sample_user.save }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, sample_user: @sample_user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, sample_user: @sample_user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @sample_user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @sample_user.microposts.dup
      @sample_user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end 
    
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, sample_user: FactoryGirl.create(:sample_user))
      end
      let(:followed_sample_user) { FactoryGirl.create(:sample_user) }
      
      before do
        @sample_user.follow!(followed_sample_user)
        3.times { followed_sample_user.microposts.create!(content: "Lorem ipsum") }
      end      

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_sample_user.microposts.each do |micropost|
          should include(micropost)
        end
      end      
    end       
  end

  describe "following" do
    let(:other_sample_user) { FactoryGirl.create(:sample_user) }    
    before do
      @sample_user.save
      @sample_user.follow!(other_sample_user)
    end

    it { should be_following(other_sample_user) }
    its(:followed_sample_users) { should include(other_sample_user) }

    describe "followed user" do
      subject { other_sample_user }
      its(:followers) { should include(@sample_user) }
    end    

    describe "and unfollowing" do
      before { @sample_user.unfollow!(other_sample_user) }

      it { should_not be_following(other_sample_user) }
      its(:followed_sample_users) { should_not include(other_sample_user) }
    end
  end    
end
