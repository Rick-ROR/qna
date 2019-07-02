FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }
    correct { false }

    trait :invalid do
      body { nil }
    end
  end
end
