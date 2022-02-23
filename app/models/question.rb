class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  def update_best_answer(answer_id)
    update_attribute(:best_answer_id, answer_id)
  end

  def ordered_answers
    #  answers_ids = []
    #  answers_ids << best_answer.id if best_answer
    #  answers_ids = answers_ids + self.answers.where.not(id: best_answer.id).ids
  end
end
