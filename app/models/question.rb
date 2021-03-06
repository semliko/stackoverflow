class Question < ApplicationRecord
  include Votable
  include Commentable
  include Subscriwable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :awards, dependent: :destroy, as: :awardable
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :links, :awards, reject_if: :all_blank
  validates_associated :links, :awards

  validates :title, :body, presence: true

  after_create :calculate_reputation, :subscribe_author

  def update_best_answer(answer_id)
    update_attribute(:best_answer_id, answer_id)
  end

  def subscription_exist?(current_user_id)
    subscriptions.exists?(user_id: current_user_id)
  end

  def assign_awards
    best_answer.awards = awards
    best_answer.save
  end

  def award_user(user_id)
    answered_user = User.find(user_id)
    awards.each { |a| answered_user.awards << a }
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author
    user.subscriptions.create(user: user, subscriwable: self)
  end
end
