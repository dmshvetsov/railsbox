class CreateCatalogCars < ActiveRecord::Migration
  def change
    create_table :catalog_cars do |t|
      t.string :external_key
      t.string :make
      t.string :model
      t.string :year

      t.timestamps null: false
    end
  end
end
