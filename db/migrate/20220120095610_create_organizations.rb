class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.text :title
      t.text :organization_id
      t.text :hidden

      t.timestamps
    end
  end
end
