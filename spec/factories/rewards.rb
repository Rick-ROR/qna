FactoryBot.define do
  factory :reward do
    question

    sequence(:title) { |n| "Reward title ##{n}" }

    trait :with_image do
      image { fixture_file_upload( file_fixture("yxMwBrJfQTY.jpg") ) }
    end
  end
end
