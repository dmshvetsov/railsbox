require 'test_helper'

feature 'Displaying structured pages content of the site' do

  scenario 'display page title in browser title' do
    create :root_section_page, title: 'Company Information', slug: 'company-information', permalink: 'company-information'

    visit '/company-information'
    page.title.must_match 'Company Information'
  end

  scenario 'display page title in browser title for nested page' do
    root_section = create :root_section_page, slug: 'company-information', permalink: 'company-information'
    create :root_section_page, title: 'About Us', parent: root_section, slug: 'about', permalink: 'company-information/about'

    visit '/company-information/about'
    page.title.must_match 'About Us'

  end

  scenario 'display content of root basic section' do
    content = create :basic_section, title: 'Information', description: 'Information section, there you can find usefull information about our company'
    create :root_section_page, content: content, slug: 'company-information', permalink: 'company-information'

    visit '/company-information'
    find('h1').text.must_equal content.title
    page.must_have_content content.description
  end

  scenario 'display content of child basic section' do
    content = create :basic_section, title: 'Sport Car Catalog', description: 'List of sports cars awailable in our store'
    root_section = create :root_section_page, slug: 'Car Catalog', permalink: 'car-catalog'
    create :section_page, parent: root_section, content: content, slug: 'Sports Cars', permalink: 'car-catalog/sports-cars'

    visit '/car-catalog/sports-cars'
    find('h1').text.must_equal content.title
    page.must_have_content content.description
  end

  scenario 'display content of root basic page' do
    content = create :basic_page, title: 'About Us', body: 'Work in progress'
    create :root_content_page, content: content, slug: 'about', permalink: 'about'

    visit '/about'
    find('h1').text.must_equal content.title
    page.must_have_content content.body
  end

  scenario 'display content of nested in section basic page' do
    content = create :basic_page, title: 'About Us', body: 'Work in progress'
    root_section = create :root_section_page, slug: 'Information', permalink: 'information'
    create :content_page, parent: root_section, content: content, slug: 'Sports Cars', permalink: 'information/about'

    visit '/information/about'
    find('h1').text.must_equal content.title
    page.must_have_content content.body
  end

end
