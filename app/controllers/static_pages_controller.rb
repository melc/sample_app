class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @micropost  = current_sample_user.microposts.build
      @feed_items = current_sample_user.feed.paginate(page: params[:page])
    end 	
  end

  def help
  end

  def about
  end

  def contact
  end

end
