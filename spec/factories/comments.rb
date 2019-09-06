FactoryBot.define do
  factory :comment do
    association :author, factory: :user

    sequence(:body) { |n| "comm ##{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
