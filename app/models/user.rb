
class User < ApplicationRecord
  attr_accessor :remember_token

  # Downcase email before saving user to ensure case insensitive uniqueness
  # before_save { self.email = self.email.downcase }
  before_save { self.email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }
                    
  # Automagically provides 
  #  - ability to save securely hashed `password_digest` attribute
  #  - virtual attributes `password` and `password_confirmation`
  #    with presence validation and matching requirement
  #  - authenticate method the returns user when password is correct
  has_secure_password

  # Returns hash digest of the given string. 
  def User.digest(string)
    # Use minimum cost in testing environment, maximum in production
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  # 
  # @return [String] the current user's remember_digest
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
    remember_digest
  end

  # @return [String] a session token to prevent session hijacking.
  def session_token
    remember_digest || remember
  end

  # Forgets a user by removing its remember_digest. Called by session.forget.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest
  def authenticated?(token_from_cookie)
    # Prevents a subtle bug involving two browsers per section 9.1.4
    return false if remember_digest.nil? 
    BCrypt::Password.new(self.remember_digest).is_password?(token_from_cookie)
  end
end
