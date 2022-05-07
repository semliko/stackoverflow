class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :awards,  as: :awardable

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  validates_associated :links

  validates :body, presence: true, allow_blank: false

  def best_answer?
    id == question.best_answer&.id
  end
end
