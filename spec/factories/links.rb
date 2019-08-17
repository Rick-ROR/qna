FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "URL ##{n}" }
    sequence(:url) { |n| "https://example.edu/#{n}" }
  end
end
