class OpenDatum < ApplicationRecord
  CATEGORIES_TRANSLATION = {
      'Tourism' => 'Туризм',  'Weather' => 'Метеоданные', 'Entertainment' => 'Досуг и отдых',
      'Electronics' => 'Электроника',  'Culture' => 'Культура', 'Ecology' => 'Экология',  'Sport' => 'Спорт',
      'Trade' => 'Торговля',  'Construction' => 'Строительство',  'Cartography' => 'Картография',
      'Government' => 'Государство',  'Health' => 'Здоровье', 'Transport' => 'Траснпорт',
      'Security' => 'Безопасность', 'Education' => 'Образование', 'Economics' => 'Экономика'
  }

  belongs_to :organization

  # some data come via API without category so... we don't check it for presence
  validates :open_datum_id, :title, presence: true

  def self.call_api(organization_tax_reference, organization_id)
    api_open_data = Api.call(organization_tax_reference)
    if api_open_data.json.any?
      OpenDatum.upsert_all(api_open_data.get_open_data(organization_id))
    end
    api_open_data.status_code
  end

  def translate_category
    CATEGORIES_TRANSLATION[self.category]
  end
end
