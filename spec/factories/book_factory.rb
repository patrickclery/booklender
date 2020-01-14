FactoryBot.define do
  factory :book do
    title { Faker::Books::Dune.title }
  end
end
