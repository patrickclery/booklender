FactoryBot.define do
  factory :book do
    created_at { Faker::Time.between(from: 1.year.ago, to: 10.days.ago) }
    title { Faker::Books::Dune.title }
    author { Faker::FunnyName.three_word_name }
    total_income_cents { Money.new(rand(10..100)) }

    trait :stub_copies do
      copies_count { rand(2..10) }
      after(:build) do |book, evaluator|
        book.loaned_copies_count = evaluator.copies_count - rand(0..evaluator.copies_count)
        book.remaining_copies_count = evaluator.copies_count - book.loaned_copies_count
      end
    end
  end
end
