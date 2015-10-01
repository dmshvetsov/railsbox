module Structure
  class ContentPage < Structure::Page

    belongs_to :section_page, class_name: 'Structure::SectionPage', foreign_key: 'parent_id'

  end
end
