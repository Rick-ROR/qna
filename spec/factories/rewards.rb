FactoryBot.define do
  factory :reward do
    question

    sequence(:title) { |n| "Reward title ##{n}" }

    trait :with_file do
      # files { fixture_file_upload(file_fixture("yxMwBrJfQTY.jpg")) }
      image { fixture_file_upload(Rails.root.join('spec/fixtures/files','yxMwBrJfQTY.jpg')) }
    end
  end
end
