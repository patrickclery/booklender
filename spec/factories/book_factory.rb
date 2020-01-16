FactoryBot.define do
  factory :book do
    created_at { Faker::Time.between(from: 1.year.ago, to: 10.days.ago) }
    title { Faker::Books::Dune.title }
    author { Faker::FunnyName.three_word_name }
  end
end
