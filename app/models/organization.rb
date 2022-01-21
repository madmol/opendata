class Organization < ApplicationRecord
  URL = 'https://data.gov.ru/'

  has_many :open_data, dependent: :destroy

  validates :organization_id, :title, presence: true
  validates :organization_id, uniqueness: true, length: { is: 10 }, format: { with: /\d/ }

  # Too much mistakes and duplicates in JSON file via API
  # validates :organization_id, uniqueness: true

  def self.save_data_from_api(organizations_data)
    organizations_data.map do |line|
      org = Organization.new
      org.organization_id = line['id']
      org.title = line['title']
      org.hidden = 'no'
      org.save
    end
    nil
  end
end
