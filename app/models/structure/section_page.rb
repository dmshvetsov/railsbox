module Structure
  class SectionPage < Structure::Page
    has_many :content_pages, -> { where(type: 'Structure::ContentPage') }, class_name: 'Structure::ContentPage', foreign_key: 'parent_id'
  end
end
