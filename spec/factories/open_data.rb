FactoryBot.define do
  factory :random_open_datum, class: Organization do
    association :organization

    open_datum_id { Faker::Code.isbn }
    title { Faker::Lorem.sentence(word_count: 5) }
    category { Faker::Lorem.word }
  end
end
