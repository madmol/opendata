class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :title
      t.string :organization_id
      t.string :hidden
      t.index [:title, :organization_id], unique: true

      t.timestamps
    end
  end
end
