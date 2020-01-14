FactoryBot.define do
  factory :user do
    name { Faker::FunnyName.name_with_initial }
    account_number { Faker::Bank.account_number }
    created_at { Faker::Time.backward(365.days) }
  end
end
