class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build  #for use with the form for creating microposts in the home view
      @feed_items = current_user.feed.paginate(page: params[:page]) # for use with the _feed partial
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
