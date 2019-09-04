FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "comm ##{n}" }
  end
end
