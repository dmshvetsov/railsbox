module Structure
  class Page < ::ActiveRecord::Base

    has_closure_tree order: :position
    acts_as_list

    belongs_to :content, polymorphic: true, dependent: :destroy
    accepts_nested_attributes_for :content, allow_destroy: true

    before_create :set_default_published_at

    # Let Rails to know how to build polymorphic Content
    def build_content attr = {}
      self.content = content_type.constantize.new(attr)
    end

    def published?
      self.published_at < Time.zone.now if self.published_at
    end

    def public?
      self.visible && self.published?
    end

    private

    def set_default_published_at
      self.published_at = Time.zone.now unless self.published_at
    end

  end
end
