class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email_address, presence: true
  validates :profile_picture_path, presence: true
end
