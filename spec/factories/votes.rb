FactoryBot.define do
  factory :vote do
    association :author, factory: :user
    association :votable, factory: :question

    state { 1 }

    trait :randomly do
      state { [1, -1].sample }
    end
  end
end
