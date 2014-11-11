class SessionsController < ApplicationController
  def new
  end

  def create
     user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #method authenticate provided by has_secure_password (in the user's model)
      log_in user #defined in sessions_helper.rb
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) #remember or forget user based on wether the remember me checkbox was checked
      remember user #defined in sessions_helper.rb
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
