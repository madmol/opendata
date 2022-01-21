class OpenDatum < ApplicationRecord
  CATEGORIES_TRANSLATION = {
      'Tourism' => 'Туризм',  'Weather' => 'Метеоданные', 'Entertainment' => 'Досуг и отдых',
      'Electronics' => 'Электроника',  'Culture' => 'Культура', 'Ecology' => 'Экология',  'Sport' => 'Спорт',
      'Trade' => 'Торговля',  'Construction' => 'Строительство',  'Cartography' => 'Картография',
      'Government' => 'Государство',  'Health' => 'Здоровье', 'Transport' => 'Траснпорт',
      'Security' => 'Безопасность', 'Education' => 'Образование', 'Economics' => 'Экономика'
  }

  belongs_to :organization

  validates :open_datum_id, :title, :category, presence: true

  class << self
    def save_data_from_api(organization_id)
      response = Faraday.get(make_api_link(Organization::URL, organization_id))

      if response.status == 200
        organization_open_data = JSON.parse(response.body)
        organization_open_data.map do |line|
          od = OpenDatum.new
          od.organization_id = organization_id
          od.title = line['title']
          od.category = line['topic']
          od.open_datum_id = line['identifier']
          od.save
        end


      end
      nil
    end

    private

    def make_api_link(url, organization_id)
      organization_tax_reference = Organization.find(organization_id).organization_id
      "#{url}api/json/organization/#{organization_tax_reference}/dataset/?access_token=#{ENV['API_KEY_OPENDATA_GOV']}"
    end
  end

  def translate_category
    CATEGORIES_TRANSLATION[self.category]
  end
end
