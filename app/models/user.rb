
class User < ApplicationRecord
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
end
