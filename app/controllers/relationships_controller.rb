class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format| #allow the controller to respond to ajax requests
      #Rails automatically calls a JS embedded Ruby (.js.erb) file with the same name as the action (create.js.erb or destroy.js.erb)
      #only one of the following lines is executed depending on the request
      format.html { redirect_to @user }
      format.js
    end
  end
end
