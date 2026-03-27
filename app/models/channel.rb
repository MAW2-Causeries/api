class Channel < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :guild, foreign_key: :guild_id, primary_key: :id, optional: true
  include HasUuid
  before_validation :normalize_name

  def as_json
    super(only: [ :id, :name, :guild_id, :description ])
  end

  def reformatted_name
    self.name.gsub(" ", "-").gsub(/[^0-9A-Za-z\s]/, "").downcase
  end

  validates :name, presence: true
  validates :type, presence: true

  private

  def normalize_name
    return if name.blank? || name.match?(/^([a-z0-9]+-?)*$/)

    self.name = reformatted_name
  end
end
