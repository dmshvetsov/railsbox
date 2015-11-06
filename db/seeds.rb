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
    { title: 'Car catalog', type: 'Structure::SectionPage', content: Catalog::Section.create(title: 'Car catalog') } => {
      { title: 'SUV', type: 'Structure::SectionPage', content: Catalog::Section.create(title: 'SUV') } => {
        { title: 'Jeep Compass', type: 'Structure::ContentPage', content: Catalog::Car.create(make: 'Jeep', model: 'Compass', year: '2015') } => {}
      },
      { title: 'Sedan', type: 'Structure::SectionPage', content: Catalog::Section.create(title: 'Sedan') } => {},
      { title: 'Sports cars', type: 'Structure::SectionPage', content: Catalog::Section.create(title: 'Sports cars') } => {},
      { title: 'Hatchback', type: 'Structure::SectionPage', content: Catalog::Section.create(title: 'Hatchback') } => {}
    },
    { title: 'About', type: 'Structure::ContentPage', content: BasicPage.create(title: 'About Us') } => {}
  }.each { |page, childs| create_page_stucture(page[:type], page, childs) }

end
