FactoryBot.define do
  factory :vote do
    association :author, factory: :user
    association :votable, factory: :question

    state { true }

    trait :randomly do
      state { [true, false].sample }
    end
  end
end
