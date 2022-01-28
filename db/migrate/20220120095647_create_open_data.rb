class CreateOpenData < ActiveRecord::Migration[6.0]
  def change
    create_table :open_data do |t|
      t.string :open_datum_id
      t.string :title
      t.string :category
      t.index [:open_datum_id], unique: true

      t.timestamps
    end
  end
end
