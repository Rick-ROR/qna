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

    trait :full_pack do

      transient do
        count_relations { 2 }
      end

      after :create do |question, evaluator|
        create_list(:link, evaluator.count_relations, linkable: question)
        create_list(:comment, evaluator.count_relations, commentable: question)
      end

      files { fixture_file_upload( file_fixture("yxMwBrJfQTY.jpg") ) }
    end
  end
end
