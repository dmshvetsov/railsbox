module Structure
  class Page < ::ActiveRecord::Base

    has_closure_tree
    acts_as_list

    belongs_to :content, polymorphic: true
    has_many :section_pages, -> { where(type: 'Structure::SectionPage') }, class_name: 'Structure::SectionPage', foreign_key: 'parent_id'
    has_many :content_pages, -> { where(type: 'Structure::ContentPage') }, class_name: 'Structure::ContentPage', foreign_key: 'parent_id'

  end
end
