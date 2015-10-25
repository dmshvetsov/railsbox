module Structure

  mattr_accessor :section_models, :content_models do
    []
  end

  def self.table_name_prefix
    'structure_'
  end

end
