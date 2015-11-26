module Structure
  # Form builder for content
  class AdminConcept

    # FIELDS is a proc that take
    # one agument, form builder
    #
    # Example:
    #   FIELDS = proc do |f|
    #     f.input :title
    #     f.input :description, as: :textarea
    #     f.input :body, as: :fancy_editor
    #   end
    #
    def self.fields
      self::FIELDS
    end

  end
end
