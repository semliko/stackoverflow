class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    CalcServices::Reputation.calculate(object)
  end
end
