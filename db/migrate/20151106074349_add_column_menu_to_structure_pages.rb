class AddColumnMenuToStructurePages < ActiveRecord::Migration
  def change
    add_column :structure_pages, :menu, :string
  end
end
