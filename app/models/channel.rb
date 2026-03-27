class Channel < ApplicationRecord
  include HasUuid
  before_validation :normalize_name
  attribute :description, :string, default: ""

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
