FactoryBot.define do
  factory :question do
    association :author, factory: :user

    sequence(:title) { |n| "#{n} # Title" }
    sequence(:body) { |n| "#{n} # Body" }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
