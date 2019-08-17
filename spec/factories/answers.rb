FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    question

    sequence(:body) { |n| "MyText ##{n}" }
    best { false }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { fixture_file_upload( file_fixture("yxMwBrJfQTY.jpg") ) }
    end
  end
end
