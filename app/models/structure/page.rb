module Structure
  class Page < ActiveRecord::Base

    belongs_to :content, polymorphic: true

  end
end
