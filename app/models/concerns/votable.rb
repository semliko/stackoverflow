module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :delete_all
    has_many :votants, through: :votes

    accepts_nested_attributes_for :votes, reject_if: :all_blank
    validates_associated :votes
  end
end
