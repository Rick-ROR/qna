FactoryBot.define do
  sequence :email do |n|
    "#{n}_user@example.edu"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.now }


    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
