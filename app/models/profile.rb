class Profile < ApplicationRecord
  belongs_to :user
  has_many :games, dependent: :destroy

  validates :username, presence: true

  # Convert platforms to an array when reading from the database
  def platforms
    super.to_s.split(',').map(&:strip)
  end

  # Convert array back to a string when saving to the database
  def platforms=(value)
    super(value.is_a?(Array) ? value.join(',') : value)
  end
end
