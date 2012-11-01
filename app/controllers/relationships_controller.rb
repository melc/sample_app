class RelationshipsController < ApplicationController
  before_filter :signed_in_sample_user

  def create
    @sample_user = SampleUser.find(params[:relationship][:followed_id])
    current_sample_user.follow!(@sample_user)
    respond_to do |format|
      format.html { redirect_to @sample_user }
      format.js
    end
  end

  def destroy
    @sample_user = Relationship.find(params[:id]).followed
    current_sample_user.unfollow!(@sample_user)
    respond_to do |format|
      format.html { redirect_to @sample_user }
      format.js
    end
  end
end