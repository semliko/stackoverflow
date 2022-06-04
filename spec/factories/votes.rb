FactoryBot.define do
  factory :vote do
    vote_type { 1 }
    user { nil }
    votable { nil }
  end
end
