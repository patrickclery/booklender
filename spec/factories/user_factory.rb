FactoryBot.define do
  factory :user do
    name { Faker::FunnyName.name_with_initial }
    account_number { Faker::Bank.account_number }
  end
end
