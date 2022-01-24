class Organization < ApplicationRecord
  URL = 'https://data.gov.ru/'

  has_many :open_data, dependent: :destroy

  validates :organization_id, :title, presence: true
  # use upsert_all instead creating instance and then saving it
  #validates :organization_id, uniqueness: true, length: { is: 10 }, format: { with: /\d/ }
end
