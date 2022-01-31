FactoryBot.define do
  factory :open_datum, class: OpenDatum do
    open_datum_id { Faker::Code.isbn }
    title { Faker::Lorem.sentence(word_count: 5) }
    category { Faker::Lorem.word }
    organization
  end
end
