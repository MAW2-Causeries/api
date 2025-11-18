class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :username, presence: true, uniqueness: true
  validates :email_address, presence: true
  validates :profile_picture_path, presence: true
end
