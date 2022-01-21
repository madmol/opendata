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

  def self.save_data_from_api(organization_open_data, organization_id)
    organization_open_data.map do |line|
      od = OpenDatum.new
      od.organization_id = organization_id
      od.title = line['title']
      od.category = line['topic']
      od.open_datum_id = line['identifier']
      od.save
      # check Organization title because of many mistakes in API data
      org = Organization.find(organization_id)
      unless org.title == line['organization_name']
        org.title = line['organization_name']
        org.save
      end
    end
    nil
  end

  def translate_category
    CATEGORIES_TRANSLATION[self.category]
  end
end
