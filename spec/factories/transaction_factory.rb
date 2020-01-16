FactoryBot.define do
  factory :transaction do
    amount_cents { 25 }
    book
    created_at { Faker::Time.between(from: 1.year.ago, to: 10.days.ago) }
    user

    trait :returned do
      returned_at { Faker::Time.backward(10) }
    end
  end

end
