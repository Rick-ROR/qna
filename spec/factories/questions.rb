FactoryBot.define do
  factory :question do
    association :author, factory: :user

    sequence(:title) { |n| "#{n} # Title" }
    sequence(:body) { |n| "#{n} # Body" }

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec','rails_helper.rb')) }
    end
  end
end
