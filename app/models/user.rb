class User < ActiveRecord::Base
  attr_accessor :remember_token
  #before_save { self.email = email.downcase }#before saving a user(self) downcase his email address. Could also have been used: self.email = self.email.downcase 
  before_save { email.downcase! } #another way to downcase the email before saving
  validates :name, presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def self.digest(string) #same as User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token #User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token #assign the user's attribute remember_token
    update_attribute(:remember_digest, User.digest(remember_token)) #update this attribute to the db (this method bypasses validations)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token) #returns true if remember_digest is the digest of remember_token
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
