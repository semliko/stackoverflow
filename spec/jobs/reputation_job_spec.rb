require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'calls Services::Reputation#calculate' do
      expect(CalcServices::Reputation).to receive(:calculate).with(question)
      ReputationJob.perform_now(question)
    end
  end
end
