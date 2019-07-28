FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    question

    body { "MyText" }
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
