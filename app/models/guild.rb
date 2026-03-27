class Guild < ApplicationRecord
  has_many :channels, foreign_key: :guild_id, primary_key: :id, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: :owner_id, primary_key: :id
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, primary_key: :id
  include HasUuid

  def as_json
    super(only: [ :id, :name, :owner_id, :description ])
  end

  validates :name, presence: true, uniqueness: true
  attribute :description, :string, default: ""
  validates :creator_id, presence: true
  validates :owner_id, presence: true
end
