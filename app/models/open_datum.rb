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

  def self.create_open_data_json_structure(organization_id)
    OpenDatum.where(organization_id: organization_id)
        .select('open_datum_id AS identifier', :title, :category).to_a.map do |record|
      # add organization info to json file and delete :id
      organization_data_hash = {
          :organization_tax_reference => Organization.find(organization_id).organization_id,
          :organization_title => Organization.find(organization_id).title
      }
      record.serializable_hash.merge!(organization_data_hash).except('id')
    end.to_json
  end

  def translate_category
    CATEGORIES_TRANSLATION[self.category]
  end
end
