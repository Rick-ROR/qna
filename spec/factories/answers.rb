FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    question

    sequence(:body) { |n| "MyText ##{n}" }
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
