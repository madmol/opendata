class OpenDatumSerializer < ActiveModel::Serializer
  attributes :title, :category
  attribute :open_datum_id, key: :identifier
  belongs_to :organization
end
