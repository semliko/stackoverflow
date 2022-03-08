class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  validates :title, :body, presence: true

  def update_best_answer(answer_id)
    update_attribute(:best_answer_id, answer_id)
  end

end
