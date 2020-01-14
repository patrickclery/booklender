FactoryBot.define do
  factory :user do
    account_number { Faker::Bank.account_number }
    created_at { Faker::Time.between(from: 1.year.ago, to: 11.days.ago) }
    name { Faker::FunnyName.name_with_initial }
  end
end
