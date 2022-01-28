FactoryBot.define do
  factory :random_organization, class: Organization do
    title { Faker::Company.name }
    organization_id { Faker::Company.russian_tax_number }
  end
end
