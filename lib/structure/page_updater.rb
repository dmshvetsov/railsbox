# = PageUpdater
#
# Updates tree of pages
# to ensure that all permalinks is correct
#
# Usage, for example when slug of some page has been changed:
#
#   page = Page.find(params[:id])
#   Structure::PageUpdater.for(page).update({ slug: 'information' })
#
module Structure
  class PageUpdater

    def self.for(object)
      new(object)
    end

    def initialize(page)
      @page = page
    end

    def update(attr)
      if @page.update(attr) && structure_changed?(attr)
        new_permalink = @page.root? ? @page.slug : [@page.parent.permalink, @page.slug].join('/')
        set_permalink_for(@page, new_permalink)
      end
      @page
    end

    private

    def structure_changed?(attr)
      attr.has_key?(:slug) || attr.has_key?(:parent_id) || attr.has_key?(:parent)
    end

    def set_permalink_for(page, new_permalink)
      page.permalink = new_permalink
      page.save
      page.children.each do |child|
        set_permalink_for(child, "#{new_permalink}/#{child.slug}")
      end
    end

  end
end
