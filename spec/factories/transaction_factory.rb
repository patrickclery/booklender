FactoryBot.define do
  factory :transaction do
    book
    user
    amount_cents { 0.25 }
    created_at { Faker::Time.between(from: 1.year.ago, to: 10.days.ago) }

    trait :returned do
      returned_at { Faker::Time.backward(10) }
    end
  end

end
