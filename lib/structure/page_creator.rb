# = PageCreator
#
# Creates pages and sets proper permalink
# to ensure that all permalinks is correct
#
# Usage:
#
#   Structure::PageCreator.for(Structure::SectionPage, page_params).create
#
module Structure
  class PageCreator

    def self.for(model, attr)
      new(model, attr)
    end

    def initialize(model, attr)
      @model = model
      @attr = attr
    end

    def create
      page = @model.create(@attr)
      page.permalink = page.root? ? page.slug : "#{page.parent.permalink}/#{page.slug}"
      page.save
      page
    end

  end
end
