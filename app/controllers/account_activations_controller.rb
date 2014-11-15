class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id]) #params[:id] contains the activation token
      #user.update_attribute(:activated,    true)
      #user.update_attribute(:activated_at, Time.zone.now)
      user.activate
      flash[:success] = "Account activated!"
      log_in user
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
