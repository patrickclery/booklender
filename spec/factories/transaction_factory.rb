FactoryBot.define do
  factory :transaction do
    book
    user
    amount_cents { 0.25 }
    created_at { Time.now - rand(1..3).days }

    trait :returned do
      returned_at { Time.now - rand(1..3).days }
    end
  end

end
