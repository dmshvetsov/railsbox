class AlterColumnsInSructurePages < ActiveRecord::Migration
  def change
    add_index :structure_pages, :slug, unique: true
  end
end
