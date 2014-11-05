class User < ActiveRecord::Base
  #before_save { self.email = email.downcase }#before saving a user(self) downcase his email address. Could also have been used: self.email = self.email.downcase 
  before_save { email.downcase! } #another way to downcase the email before saving
  validates :name, presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: { minimum: 6 }
end
