class AddPositionToStructurePages < ActiveRecord::Migration
  def change
    add_column :structure_pages, :position, :integer
  end
end
