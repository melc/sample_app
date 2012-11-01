class SampleUsersController < ApplicationController
  before_filter :signed_in_sample_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_sample_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @sample_users = SampleUser.paginate(page: params[:page])
  end

  def new
  	@sample_user = SampleUser.new
  end

  def edit
    @sample_user = SampleUser.find(params[:id])
  end

  def show
  	@sample_user = SampleUser.find(params[:id])
    @microposts = @sample_user.microposts.paginate(page: params[:page])    
  end

  def create
    @sample_user = SampleUser.new(params[:sample_user])
    if @sample_user.save
       sign_in @sample_user
       flash[:success] = "Welcome to the TwinPets.com Twitter Alike Demo!"
       redirect_to @sample_user
    else
      render 'new'
    end
  end

  def update
    @sample_user = SampleUser.find(params[:id])
    if @sample_user.update_attributes(params[:sample_user])
      flash[:success] = "Profile updated"
      sign_in @sample_user
      redirect_to @sample_user
    else
      render 'edit'
    end
  end

  def destroy
    SampleUser.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to sample_users_url
  end  

  def following
    @title = "Following"
    @sample_user = SampleUser.find(params[:id])
    @sample_users = @sample_user.followed_sample_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @sample_user = SampleUser.find(params[:id])
    @sample_users = @sample_user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def signed_in_sample_user
      unless signed_in?
        store_location    
        redirect_to signin_url, notice: "Please sign in." 
      end
    end

    def correct_sample_user
      @sample_user = SampleUser.find(params[:id])
      redirect_to(root_path) unless current_sample_user?(@sample_user)
    end  

    def admin_user
      redirect_to(root_path) unless current_sample_user.admin?
    end
end    