module Structure
  class Page < ::ActiveRecord::Base

    has_closure_tree order: :position
    acts_as_list

    belongs_to :content, polymorphic: true, dependent: :destroy
    accepts_nested_attributes_for :content, allow_destroy: true

    def build_content attr = {}
      # content_model = attr.delete :content_type
      # content_model.constantize.build(attr)
      self.content = content_type.constantize.new(attr)
    end

  end
end
