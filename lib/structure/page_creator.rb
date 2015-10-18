# = PageCreator
#
# Creates pages and sets proper permalink
# to ensure that all permalinks is correct
#
# Usage:
#
#   Structure::PageCreator.for(page_params).create
#
module Structure
  class PageCreator

    def self.for(attr)
      new(attr)
    end

    def initialize(attr)
      @attr = attr
    end

    def create
      page = Page.create(@attr)
      page.permalink = page.root? ? page.slug : "#{page.parent.permalink}/#{page.slug}"
      page.save
      page
    end

  end
end
