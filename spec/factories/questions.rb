FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "#{n} # Title" }
    sequence(:body) { |n| "#{n} # Body" }

    trait :invalid do
      title { nil }
    end
  end
end
