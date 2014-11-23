class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') } #the arrow -> takes in a block and returns a Proc which can then be evaulated with the call method
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  #def Micropost.from_users_followed_by(user) #non-optimal solution
  #  following_ids = user.following_ids #same as user.following.map{ |x| x.id}
  #  where("user_id IN (?) OR user_id = ?", following_ids, user)
  #end

  # implementation 2
  #def Micropost.from_users_followed_by(user)
  #  following_ids = user.following_ids
   # where("user_id IN (:following_ids) OR user_id = :user_id", following_ids: following_ids, user_id: user)
    # the above line is equivalent to: where("user_id IN (?) OR user_id = ?", following_ids, user)
 # end

  #implementation 3
  # Returns microposts from the users being followed by the given user.
  def Micropost.from_users_followed_by(user)
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: user)
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
