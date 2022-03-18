class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true, allow_blank: false

  def best_answer?
    id == question.best_answer&.id
  end
end
