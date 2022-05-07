class Award < ApplicationRecord
  belongs_to :awardable, polymorphic: true

  has_one_attached :file
  validates :name, presence: true

end
