FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }
    correct { false }
  end
end
