module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :delete_all
    has_many :votants, through: :votes
  end

  def votes_count
    { upvotes: upvotes_count, downvotes: downvotes_count, total: total_votes_count }
  end

  def upvotes_count
    votes.upvote.count
  end

  def downvotes_count
    votes.downvote.count
  end

  def total_votes_count
    upvotes_count - downvotes_count
  end
end
