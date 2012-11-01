require 'spec_helper'

describe Micropost do

  let(:sample_user) { FactoryGirl.create(:sample_user) }
  before { @micropost = sample_user.microposts.build(content: "Lorem ipsum") }
  
  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:sample_user_id) }
  it { should respond_to(:sample_user) }
  its(:sample_user) { should == sample_user }  

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(sample_user_id: sample_user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end   

  describe "when user_id is not present" do
    before { @micropost.sample_user_id = nil }
    it { should_not be_valid }
  end   

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end