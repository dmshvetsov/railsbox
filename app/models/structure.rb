module Structure

  def self.content_types
    [
      'BasicSection',
      'BasicPage',
      'Catalog::Section',
      'Catalog::Car'
    ]
  end

  def self.table_name_prefix
    'structure_'
  end

  # The mock of the virtual non persisted root page
  def self.root_page
    Page.new(title: I18n.t('structure.pages.root'), slug: '', permalink: '')
  end

end
