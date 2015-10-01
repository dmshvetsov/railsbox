module Structure
  class Page < ::ActiveRecord::Base

    has_closure_tree
    acts_as_list

    belongs_to :content, polymorphic: true

  end
end
