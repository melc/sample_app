module SessionsHelper
	def sign_in(sample_user)
   	cookies.permanent[:remember_token] = sample_user.remember_token
   	self.current_sample_user = sample_user
  end

  def current_sample_user=(sample_user)
   	@current_sample_user = sample_user
  end

  def current_sample_user
   	@current_sample_user ||= SampleUser.find_by_remember_token(cookies[:remember_token])
  end

  def current_sample_user?(sample_user)
    sample_user == current_sample_user
  end  

  def signed_in?
   	!current_sample_user.nil?
  end

  def signed_in_sample_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end  
  
  def sign_out
    self.current_sample_user = nil
    cookies.delete(:remember_token)
  end    

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end  

end
