class CreateOpenData < ActiveRecord::Migration[6.0]
  def change
    create_table :open_data do |t|
      t.text :open_datum_id
      t.text :title
      t.text :category

      t.timestamps
    end
  end
end
