if Rails.env == 'development'
  # Users
  User.create(email: 'shvetsovdm@gmail.com', password: '12345678')

  # Pages
  Structure::Page.delete_all

  def create_page_stucture(type, attr, childs)
    page = Structure::PageCreator.for(type.constantize, attr).create

    childs.each do |subpage, subchilds|
      subpage[:parent_id] = page.id
      create_page_stucture(subpage[:type], subpage, subchilds)
    end
  end

  {
    { title: 'Car catalog', type: 'Structure::SectionPage', menu: 'CatalogMenu', content: Catalog::Section.create(title: 'Car catalog') } => {
      { title: 'SUV', type: 'Structure::SectionPage', menu: 'CatalogMenu', content: Catalog::Section.create(title: 'SUV') } => {
        { title: 'Jeep Compass', type: 'Structure::ContentPage', menu: 'CatalogMenu', content: Catalog::Car.create(make: 'Jeep', model: 'Compass', year: '2015') } => {}
      },
      { title: 'Sedan', type: 'Structure::SectionPage', menu: 'CatalogMenu', content: Catalog::Section.create(title: 'Sedan') } => {},
      { title: 'Sports cars', type: 'Structure::SectionPage', menu: 'CatalogMenu', content: Catalog::Section.create(title: 'Sports cars') } => {},
      { title: 'Hatchback', type: 'Structure::SectionPage', menu: 'CatalogMenu', content: Catalog::Section.create(title: 'Hatchback') } => {}
    },
    { title: 'WIP', type: 'Structure::SectionPage', menu: 'MainMenu', visible: false, content: BasicSection.create(title: 'empty') } => {
      { title: 'draft', type: 'Structure::ContentPage', menu: 'MainMenu', content: BasicPage.create(title: 'draft page') } => {},
    },
    { title: 'About', type: 'Structure::ContentPage', menu: 'MainMenu', content: BasicPage.create(title: 'About Us') } => {},
    { title: 'Contacts', type: 'Structure::ContentPage', menu: 'MainMenu', content: BasicPage.create(title: 'Contacts') } => {}
  }.each { |page, childs| create_page_stucture(page[:type], page, childs) }

end
