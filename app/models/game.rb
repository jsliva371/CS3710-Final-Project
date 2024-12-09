class Game < ApplicationRecord
  belongs_to :profile

  # Manually serialize achievements as an array of strings
  def achievements
    read_attribute(:achievements).split(',') if read_attribute(:achievements).present?
  end

  def achievements=(value)
    write_attribute(:achievements, value.join(',')) if value.is_a?(Array)
  end

  # Default achievements to an empty array
  after_initialize do
    self.achievements ||= []
  end

  validates :name, :rank, :main, presence: true
end
