require 'spec_helper'

describe RelationshipsController do

  let(:sample_user) { FactoryGirl.create(:sample_user) }
  let(:other_sample_user) { FactoryGirl.create(:sample_user) }

  before { sign_in sample_user }

  describe "creating a relationship with Ajax" do

    it "should increment the Relationship count" do
      expect do
        xhr :post, :create, relationship: { followed_id: other_sample_user.id }
      end.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relationship: { followed_id: other_sample_user.id }
      response.should be_success
    end
  end

  describe "destroying a relationship with Ajax" do

    before { sample_user.follow!(other_sample_user) }
    let(:relationship) { sample_user.relationships.find_by_followed_id(other_sample_user) }

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      response.should be_success
    end
  end
end