require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :answers }
  it { should have_many :questions }
  it { should have_many :awards }
  it { should have_many :votes }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234') }
    let(:service) { double('AuthServices::FindForOauth') }

    context 'calls Service:FindForOauth' do
      it 'calls Service:FindForOauth' do
        expect(AuthServices::FindForOauth).to receive(:new).with(auth).and_return(service)
        expect(service).to receive(:call)
        User.find_for_oauth(auth)
      end
    end
  end
end
