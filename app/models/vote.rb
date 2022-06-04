class Vote < ApplicationRecord
  enum vote_type: [:upvote, :downvote]
  belongs_to :user
  belongs_to :votable, polymorphic: true
end
