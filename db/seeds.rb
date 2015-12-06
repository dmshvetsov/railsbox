if Rails.env == 'development'
  # Users
  User.create(email: 'shvetsovdm@gmail.com', password: '12345678')

  # Pages
  Structure::Page.delete_all

  def create_page_stucture(attr, childs)
    page = Structure::PageCreator.for(Structure::Page, attr).create

    childs.each do |subpage, subchilds|
      subpage[:parent_id] = page.id
      create_page_stucture(subpage, subchilds)
    end
  end

  {
    { title: 'Car catalog', menu: 'CatalogMenu', language: 'en', content: Catalog::Section.create(title: 'Car catalog') } => {
      { title: 'SUV', menu: 'CatalogMenu', language: 'en', content: Catalog::Section.create(title: 'SUV') } => {
        { title: 'Jeep Compass', menu: 'CatalogMenu', language: 'en', content: Catalog::Car.create(make: 'Jeep', model: 'Compass', year: '2015') } => {}
      },
      { title: 'Sedan', menu: 'CatalogMenu', language: 'en', content: Catalog::Section.create(title: 'Sedan') } => {},
      { title: 'Sports cars', menu: 'CatalogMenu', language: 'en', content: Catalog::Section.create(title: 'Sports cars') } => {},
      { title: 'Hatchback', menu: 'CatalogMenu', language: 'en', content: Catalog::Section.create(title: 'Hatchback') } => {},
      { title: 'Info', menu: 'CatalogMenu', language: 'en', content: BasicSection.create(title: 'Information about catalog') } => {
        { title: 'How to use', menu: 'CatalogMenu', language: 'en', content: BasicPage.create(title: 'How to use', body: 'WIP') } => {}
      }
    },
    { title: 'WIP', menu: 'MainMenu', language: 'en', visible: false, content: BasicSection.create(title: 'empty') } => {
      { title: 'draft', menu: 'MainMenu', language: 'en', content: BasicPage.create(title: 'draft page') } => {},
    },
    { title: 'About', menu: 'MainMenu', language: 'en', content: BasicPage.create(title: 'About Us') } => {},
    { title: 'Contacts', menu: 'MainMenu', language: 'en', content: BasicPage.create(title: 'Contacts') } => {},
    { title: 'Documentation', menu: 'MainMenu', language: 'en', content: BasicSection.create(title: 'Documentation') } => {
      { title: 'License', menu: 'MainMenu', language: 'en', content: BasicPage.create(title: 'License') } => {}
    }
  }.each { |page, childs| create_page_stucture(page, childs) }

end
