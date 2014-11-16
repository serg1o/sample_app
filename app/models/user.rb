class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  #before_save { self.email = email.downcase }#before saving a user(self) downcase his email address. Could also have been used: self.email = self.email.downcase
  # self is optional inside the model if ther's no ambiguities
  #before_save { email.downcase! } #another way to downcase the email before saving
  validates :name, presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true #allow the user to submit blank passwords when updating his profile.
  #This only applies to updating users and not to creating users which enforces presence of password through has_secure_password

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
 # def authenticated?(remember_token)
   # return false if remember_digest.nil?
   # BCrypt::Password.new(remember_digest).is_password?(remember_token) #returns true if remember_digest is the digest of remember_token
  #end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    # the send method lets us call a method with a name of our choice by “sending a message” to a given object
    # in this case we're calling the attribute named "#{attribute}_digest" on this model (User)
    digest = send("#{attribute}_digest") #digest = self.send("#{attribute}_digest") -> also works
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    #update_attribute(:activated,    true)
    #update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    #update_attribute(:reset_digest,  User.digest(reset_token))
    #update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
