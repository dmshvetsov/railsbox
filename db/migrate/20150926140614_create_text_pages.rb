class CreateTextPages < ActiveRecord::Migration
  def change
    create_table :text_pages do |t|
      t.string :title
      t.text :body

      t.timestamps null: false
    end
  end
end
