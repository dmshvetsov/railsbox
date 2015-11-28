require 'test_helper'
require 'support/active_admin_helper'

feature 'Manage structure of the sites pages' do

  include ActiveAdminHelper

  # Helpers
  def into_site_structure_page
    click_link 'Site Structure'
  end

  def into_form type
    click_link "Create #{type}"
  end

  def into_section_page title
    within '.table-with-tree__categorizer.panel' do
      click_link title
    end
  end

  def into_edit_current_section
    click_link 'Edit section'
  end

  def into_edit_content_page content, section
    find("a[href=\"#{edit_admin_structure_content_page_path(content)}?parent_id=#{section.id}\"]").click
  end

  def categorizer_panel
    find '.table-with-tree__categorizer.panel'
  end

  def current_section
    within categorizer_panel do
      find :xpath, '//a[@class="active"]'
    end
  end

  # Tests
  scenario 'Main menu is selected by default' do
    create :root_section_page, title: 'Car Catalog', menu: 'MainMenu'
    user = create :user
    admin_login user

    into_site_structure_page
    current_section.text.must_equal '- Main Menu'
  end

  scenario 'always show root link for sections' do
    root_section = create :root_section_page, title: 'Car Catalog'
    create :section_page, title: '4WD', parent: root_section
    user = create :user
    admin_login user

    into_site_structure_page
    categorizer_panel.must_have_link 'Main Menu', href: admin_structure_section_pages_path(menu: 'MainMenu')

    into_section_page 'Car Catalog'
    categorizer_panel.must_have_link 'Main Menu', href: admin_structure_section_pages_path(menu: 'MainMenu')

    into_section_page '4WD'
    categorizer_panel.must_have_link 'Main Menu', href: admin_structure_section_pages_path(menu: 'MainMenu')
  end

  scenario 'switch language'

  scenario 'create root section' do
    user = create :user
    admin_login user

    into_site_structure_page
    into_form 'Basic section'

    assert_difference 'Structure::SectionPage.count', 1 do
      fill_in 'structure_section_page[title]', with: 'Car Catalog'
      check 'structure_section_page[visible]'
      submit_form
    end

    page.must_have_content 'Car Catalog'
    current_section.text.must_equal 'Car Catalog'
  end

  scenario 'display root content pages in Root of site structure' do
    skip 'with virtual root page this will not work, will work with real root per lang page'
    user = create :user
    admin_login user

    create(:content_page, parent_id: nil, title: 'How to make order')

    into_site_structure_page
    current_section.text.must_equal 'Root'
    page.must_have_content 'How to make order'
  end

  scenario 'delete section' do
    skip 'test somehow fails'

    create :root_section_page, title: 'Car Catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Car Catalog'
    assert_difference 'Structure::SectionPage.count', -1 do
      click_link 'Delete section'
    end

    page.wont_have_content 'Car Catalog'
    # TODO: test current_section
  end

  scenario 'edit section page' do
    section = create :root_section_page, title: 'Car Catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Car Catalog'
    into_edit_current_section

    fill_in 'structure_section_page[title]', with: 'Auto Catalog'
    submit_form

    section.reload
    section.title.must_equal 'Auto Catalog'
  end

  scenario 'create child section' do
    root_page = create :root_section_page, title: 'Car Catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Car Catalog'
    into_form 'Basic section'

    parent_section = find('select[name="structure_section_page[parent_id]"]').value
    parent_section.must_equal root_page.id.to_s

    assert_difference 'Structure::SectionPage.count', 1 do
      fill_in 'structure_section_page[title]', with: '4WD'
      check 'structure_section_page[visible]'
      submit_form
    end

    page.must_have_content '4WD'
    Structure::SectionPage.last.parent_id.must_equal root_page.id
    current_section.text.must_equal '4WD'
  end

  scenario 'create section page with content' do
    user = create :user
    admin_login user

    into_site_structure_page
    into_form 'Basic section'

    assert_difference 'BasicSection.count', 1 do
      fill_in 'structure_section_page[title]', with: '4WD'
      check 'structure_section_page[visible]'
      fill_in 'structure_section_page[content_attributes][title]', with: '4WD Cars'
      fill_in 'structure_section_page[content_attributes][description]', with: '4Wheel Drive Hardware Cars'
      submit_form
    end

    section_page_content = Structure::SectionPage.last.content
    section_page_content.title.must_equal '4WD Cars'
    section_page_content.description.must_equal '4Wheel Drive Hardware Cars'
  end

  scenario 'create structure of pages' do
    user = create(:user)
    admin_login user
    into_site_structure_page

    into_form 'Basic section'
    fill_in 'structure_section_page[title]', with: 'Car catalog'
    fill_in 'structure_section_page[content_attributes][title]', with: 'Car catalog'
    submit_form

    current_section.text.must_equal 'Car catalog'

    into_form 'Basic section'
    fill_in 'structure_section_page[title]', with: 'SVU'
    fill_in 'structure_section_page[content_attributes][title]', with: 'Sport utility vehicle'
    submit_form

    current_section.text.must_equal 'SVU'

    into_form 'Basic page'
    fill_in 'structure_content_page[title]', with: 'Jeep Compass'
    fill_in 'structure_content_page[content_attributes][title]', with: 'Jeep Compass'
    submit_form

    Structure::Page.find_by(slug: 'car-catalog').permalink.must_equal 'car-catalog'
    Structure::Page.find_by(slug: 'svu').permalink.must_equal 'car-catalog/svu'
    Structure::Page.find_by(slug: 'jeep-compass').permalink.must_equal 'car-catalog/svu/jeep-compass'
  end

  scenario 'change parent of content page' do
    user = create(:user)
    admin_login user

    catalog = create(:section_page, title: 'Car catalog', slug: 'car-catalog', permalink: 'car-catalog')
    catalog_section = create(:section_page, title: 'SVU', slug: 'svu', permalink: 'car-catalog/svu', parent: catalog)
    content_page = create(:content_page, title: 'Jeep Compass', slug: 'compass', permalink: 'car-catalog/svu/compass', parent: catalog_section)

    into_site_structure_page
    into_section_page 'Car catalog'
    into_section_page 'SVU'
    into_edit_content_page content_page, catalog_section

    select 'Car catalog', from: 'structure_content_page[parent_id]'
    submit_form

    Structure::Page.find_by(slug: 'car-catalog').permalink.must_equal 'car-catalog'
    Structure::Page.find_by(slug: 'svu').permalink.must_equal 'car-catalog/svu'
    Structure::Page.find_by(slug: 'compass').permalink.must_equal 'car-catalog/compass'
  end

  scenario 'change parent of section page with content page' do
    user = create(:user)
    admin_login user

    catalog = create(:section_page, title: 'Car catalog', slug: 'car-catalog', permalink: 'car-catalog')
    catalog_section = create(:section_page, title: 'SVU', slug: 'svu', permalink: 'car-catalog/svu', parent: catalog)
    create(:section_page, title: 'Jeep Compass', slug: 'compass', permalink: 'car-catalog/svu/compass', parent: catalog_section)

    into_site_structure_page
    into_section_page 'Car catalog'
    into_section_page 'SVU'
    into_edit_current_section

    select nil, from: 'structure_section_page[parent_id]'
    submit_form

    Structure::Page.find_by(slug: 'car-catalog').permalink.must_equal 'car-catalog'
    Structure::Page.find_by(slug: 'svu').permalink.must_equal 'svu'
    Structure::Page.find_by(slug: 'compass').permalink.must_equal 'svu/compass'
  end

  scenario 'edit content page' do
    section = create :root_section_page, title: 'Car Catalog'
    content = create :content_page, title: 'Jeep Compass', parent: section
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Car Catalog'
    into_edit_content_page content, section

    fill_in 'structure_content_page[title]', with: 'Jeep Compass 2015'
    submit_form

    content.reload
    content.title.must_equal 'Jeep Compass 2015'
  end

  scenario 'delete content page' do
    skip 'test somehow fails'

    section = create :root_section_page, title: 'Car Catalog'
    content = create :content_page, title: 'Jeep Compass', parent: section
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Car Catalog'
    assert_difference 'Structure::ContentPage.count', -1 do
      find(:xpath, "//a[@data-method='delete' and @href='#{admin_structure_content_page_path(content)}']").click
    end

    page.wont_have_content 'Jeep Compass'
    # TODO: test current_section
  end

  scenario 'can not create content page without choosing section page' do
    user = create :user
    admin_login user

    into_site_structure_page
    page.wont_have_content 'Create Content Page'
  end

  scenario 'create content page in section' do
    root_page = create :root_section_page, title: 'Car Catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Car Catalog'
    into_form 'Basic page'

    parent_section = find('select[name="structure_content_page[parent_id]"]').value
    parent_section.must_equal root_page.id.to_s

    assert_difference 'Structure::ContentPage.count', 1 do
      fill_in 'structure_content_page[title]', with: 'Jeep Compass'
      check 'structure_content_page[visible]'
      submit_form
    end

    page.must_have_content 'Jeep Compass'
    Structure::ContentPage.last.parent_id.must_equal root_page.id
    current_section.text.must_equal 'Car Catalog'
  end

  scenario 'create content page with content' do
    create :root_section_page, title: 'Information'
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Information'
    into_form 'Basic page'

    assert_difference 'BasicPage.count', 1 do
      fill_in 'structure_content_page[title]', with: 'About company'
      check 'structure_content_page[visible]'
      fill_in 'structure_content_page[content_attributes][title]', with: 'About'
      fill_in 'structure_content_page[content_attributes][body]', with: 'Work in progress'
      submit_form
    end

    last_content_page_content = Structure::ContentPage.last.content
    last_content_page_content.title.must_equal 'About'
    last_content_page_content.body.must_equal 'Work in progress'
  end

  scenario 'Cancel from Section Page form leads to this Section Page in categorizer' do
    create :root_section_page, title: 'Information'
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Information'
    into_edit_current_section

    click_link 'Cancel'
    current_path.must_equal admin_structure_section_pages_path
    current_section.text.must_equal 'Information'
  end

  scenario 'Cancel from Content Page form leads to parent Section Page in categorizer' do
    section = create :root_section_page, title: 'Information'
    content = create :content_page, parent: section
    user = create :user
    admin_login user

    into_site_structure_page
    into_section_page 'Information'
    into_edit_content_page content, section

    click_link 'Cancel'
    current_path.must_equal admin_structure_section_pages_path
    current_section.text.must_equal 'Information'
  end

end
