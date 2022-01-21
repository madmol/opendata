class Organization < ApplicationRecord
  URL = 'https://data.gov.ru/'

  has_many :open_data, dependent: :destroy

  validates :organization_id, :title, presence: true

  # Too much mistakes and duplicates in JSON file via API
  # validates :organization_id, uniqueness: true

  class << self
    def save_data_from_api
      response = Faraday.get(make_api_link(URL))

      if response.status == 200
        organizations_data = JSON.parse(response.body)
        organizations_data.map do |line|
          org = Organization.new
          org.organization_id = line['id']
          org.title = line['title']
          org.hidden = 'no'
          org.save
        end
      end
      nil
    end

    private

    def make_api_link(url)
      "#{url}api/json/organization/?access_token=#{ENV['API_KEY_OPENDATA_GOV']}"
    end
  end
end
