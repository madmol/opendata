class AddOrganizationToOpenDatum < ActiveRecord::Migration[6.0]
  def change
    add_reference :open_data, :organization, null: false, foreign_key: true
  end
end
