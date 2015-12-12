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

  def self.m_configuration
    @m_configuration ||= Structure::Configuration.new
  end

  def self.m_configure
    yield(m_configuration)
  end

  def self.menus
    m_configuration.menus
  end

end
