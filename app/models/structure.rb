module Structure

  def self.content_models
    ['BasicPage', 'Catalog::Car']
  end

  def self.section_models
    ['BasicSection', 'Catalog::Section']
  end

  def self.table_name_prefix
    'structure_'
  end

end
