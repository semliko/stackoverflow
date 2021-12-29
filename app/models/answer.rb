class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true, allow_blank: false
end
