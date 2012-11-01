class SessionsController < ApplicationController

  def new
  end

  def create
  	sample_user = SampleUser.find_by_email(params[:session][:email].downcase)
  	if sample_user && sample_user.authenticate(params[:session][:password])
    	# Sign the user in and redirect to the user's show page.
	    sign_in sample_user
      redirect_back_or sample_user    	
  	else
    	# Create an error message and re-render the signin form.
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'    	
  	end  	
  end

  def destroy
    sign_out
    redirect_to root_url    
  end
  
end
