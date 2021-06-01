class User < ApplicationRecord
  after_create :create_api_key

  validates :email, presence: true, uniqueness: true
  validates :email, presence: true

  has_secure_password

  def create_api_key
    self.update_attribute(:api_key, SecureRandom.hex)
  end
end
