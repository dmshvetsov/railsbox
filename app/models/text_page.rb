class TextPage < ActiveRecord::Base

  has_one :page, as: :content, class_name: Structure::Page, dependent: :destroy

  accepts_nested_attributes_for :page

end
