module Structure
  class Page < ::ActiveRecord::Base

    include FriendlyId
    include ::Cell::RailsExtensions::ActionController

    has_closure_tree order: :position
    acts_as_list

    # Associations
    belongs_to :content, polymorphic: true, dependent: :destroy
    accepts_nested_attributes_for :content, allow_destroy: true

    # Validations
    validates :title, presence: true, uniqueness: true

    # Callbacks
    before_create :set_default_published_at

    scope :is_published, -> { where('published_at < ?', Time.zone.now) }
    scope :is_visible, -> { where(visible: true) }
    scope :is_public, -> { is_published.is_visible }
    scope :item, ->(params) do
      norm_params = params.dup
      norm_params[:language] = I18n.default_locale if params[:language].nil?
      find_by(language: norm_params[:language], permalink: norm_params[:permalink])
    end
    scope :items, ->(params) do
      norm_params = params.dup
      norm_params[:language] = I18n.default_locale if params[:language].nil?
      where(menu: norm_params[:menu], language: norm_params[:language])
    end

    # Let Rails to know how to build polymorphic Content
    def build_content(attr = {})
      self.content = content_type.constantize.new(attr)
    end

    # Override FriendlyId method
    # to not allow empty string to become a slug
    def should_generate_new_friendly_id?
      send(friendly_id_config.slug_column).blank? && !send(friendly_id_config.base).blank?
    end

    # FrendlyId slug variants
    # for FriendlyId configuration look for config/initializers/firendly_id.rb
    def attribute_to_slug
      [:title]
    end

    def published?
      self.published_at < Time.zone.now if self.published_at
    end

    def public?
      self.visible && self.published?
    end

    def build_concept
      concept("#{content_type}::Cell::Show".underscore, self)
    end

    private

    def set_default_published_at
      self.published_at = Time.zone.now unless self.published_at
    end

  end
end
