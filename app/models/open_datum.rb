class OpenDatum < ApplicationRecord
  CATEGORIES_TRANSLATION = {
    'Tourism' => 'Туризм',  'Weather' => 'Метеоданные', 'Entertainment' => 'Досуг и отдых',
    'Electronics' => 'Электроника',  'Culture' => 'Культура', 'Ecology' => 'Экология',  'Sport' => 'Спорт',
    'Trade' => 'Торговля',  'Construction' => 'Строительство',  'Cartography' => 'Картография',
    'Government' => 'Государство',  'Health' => 'Здоровье', 'Transport' => 'Траснпорт',
    'Security' => 'Безопасность', 'Education' => 'Образование', 'Economics' => 'Экономика'
  }

  belongs_to :organization

  # validates :open_datum_id, :title, presence: true

  def self.save_api_data(data)
    if data.any?
      OpenDatum.upsert_all(data, unique_by: :index_open_data_on_open_datum_id)
    end
  end

  def translate_category
    CATEGORIES_TRANSLATION[category]
  end
end
