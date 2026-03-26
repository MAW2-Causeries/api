class Guild < ApplicationRecord
  has_many :channels, foreign_key: :guild_id, primary_key: :id, dependent: :destroy
  belongs_to :user, foreign_key: :owner_id, primary_key: :id
  belongs_to :user, foreign_key: :creator_id, primary_key: :id
  include HasUuid

  def as_json
    super(only: [ :id, :name, :owner_id, :description ])
  end

  validates :name, presence: true, uniqueness: true
  validates :banner_picture_path, presence: true
  validates :creator_id, presence: true
  validates :owner_id, presence: true
end
