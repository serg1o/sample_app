module SessionsHelper

 # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember #generate remember_token and save its digest in the db
    cookies.permanent.signed[:user_id] = user.id #create a permanent cookie with the encrypted id of the user to send to the browser
    cookies.permanent[:remember_token] = user.remember_token #create a permanent cookie with the remember_token to send to the browser
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id]) #if session[:user_id] exists put its value in user_id and run the if block
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)   
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

 # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) #prevent accessing the db if @current_user is already set
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
