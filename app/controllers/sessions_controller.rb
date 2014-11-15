class SessionsController < ApplicationController
  def new
  end

  def create
    # user = User.find_by(email: params[:session][:email].downcase)
    #if user && user.authenticate(params[:session][:password]) #method authenticate provided by has_secure_password (in the user's model)
     # log_in user #defined in sessions_helper.rb
     # params[:session][:remember_me] == '1' ? remember(user) : forget(user) #remember or forget user based on wether the remember me checkbox was checked
     # remember user #defined in sessions_helper.rb
    #  redirect_to user

    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password]) #method authenticate provided by has_secure_password (in the user's model)
     # log_in @user #defined in sessions_helper.rb
     # params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) #remember or forget user based on wether the remember me checkbox was checked
    # # remember user #defined in sessions_helper.rb  
    #  #redirect_to @user
     # redirect_back_or @user  #it's redirect_back_or user in the book
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
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
