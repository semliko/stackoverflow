class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, allow_blank: false

  def best_answer?
    id == question.best_answer&.id
  end
end
