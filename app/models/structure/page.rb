module Structure
  class Page < ::ActiveRecord::Base

    acts_as_list

    belongs_to :content, polymorphic: true

  end
end
