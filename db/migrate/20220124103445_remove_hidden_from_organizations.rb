class RemoveHiddenFromOrganizations < ActiveRecord::Migration[6.0]
  def change
    remove_column :organizations, :hidden, :string
  end
end
