class CreateStructurePages < ActiveRecord::Migration
  def change
    create_table :structure_pages do |t|
      t.string :title
      t.string :slug
      t.string :permalink
      t.integer :parent_id
      t.boolean :visible, default: true
      t.datetime :published_at
      t.string :language
      t.references :content, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
