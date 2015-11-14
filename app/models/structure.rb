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

  # The mock of the virtual non persisted root page
  def self.root_page
    Page.new(title: I18n.t('structure.pages.root'), slug: '', permalink: '')
  end

end
