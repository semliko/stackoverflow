class Subscription < ApplicationRecord
  belongs_to :subscriwable, polymorphic: true
  belongs_to :user
end
