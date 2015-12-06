class RemoveColumnTypeFromStructurePages < ActiveRecord::Migration
  def change
    remove_column :structure_pages, :type, :string
  end
end
