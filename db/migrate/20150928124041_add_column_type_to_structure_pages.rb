class AddColumnTypeToStructurePages < ActiveRecord::Migration
  def change
    add_column :structure_pages, :type, :string
  end
end
