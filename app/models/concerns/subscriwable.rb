module Subscriwable
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, as: :subscriwable, dependent: :delete_all
    has_many :subscribers, through: :subscriptions
  end
end
