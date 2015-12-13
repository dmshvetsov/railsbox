require 'test_helper'
require 'support/active_admin_helper'

feature 'Manage structure of the sites pages' do

  include ActiveAdminHelper

  # Helpers
  def into_site_structure_page
    click_link 'Structure Pages'
  end

  def into_form type
    within '#titlebar_right .dropdown_menu_list' do
      find_link(type, visible: :all).click
    end
  end

  def into_categorizer_page title
    within '.table-with-tree__categorizer.panel' do
      click_link title
    end
  end

  def into_edit_current_page
    click_link 'Edit Page'
  end

  def into_edit_content_page content
    find("a.edit_link.member_link[href=\"#{edit_admin_structure_page_path(content.slug)}\"]").click
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
    create :root_page, title: 'Car Catalog', menu: 'MainMenu'
    user = create :user
    admin_login user

    into_site_structure_page
    current_section.text.must_equal '- Main Menu'
  end

  scenario 'always show root link for sections' do
    root_section = create(:root_page, title: 'Car Catalog', permalink: 'car-catalog')
    create(:page, title: '4WD', parent: root_section, permalink: 'car-catalog/4wd')
    user = create(:user)
    admin_login user

    into_site_structure_page
    categorizer_panel.must_have_link 'Main Menu', href: admin_structure_pages_path(menu: 'MainMenu')

    into_categorizer_page 'Car Catalog'
    categorizer_panel.must_have_link 'Main Menu', href: admin_structure_pages_path(menu: 'MainMenu')

    into_categorizer_page '4WD'
    categorizer_panel.must_have_link 'Main Menu', href: admin_structure_pages_path(menu: 'MainMenu')
  end

  scenario 'switch language'

  scenario 'create root section' do
    user = create :user
    admin_login user

    into_site_structure_page
    into_form 'Basic section'

    assert_difference 'Structure::Page.count', 1 do
      fill_in 'structure_page[title]', with: 'Car Catalog'
      check 'structure_page[visible]'
      submit_form
    end

    page.must_have_content 'Car Catalog'
    current_section.text.must_equal 'Car Catalog'
  end

  scenario 'display root content pages in Root of site structure' do
    skip 'with virtual root page this will not work, will work with real root per lang page'
    user = create :user
    admin_login user

    create(:page, parent_id: nil, title: 'How to make order')

    into_site_structure_page
    current_section.text.must_equal 'Root'
    page.must_have_content 'How to make order'
  end

  scenario 'delete section' do
    skip 'test somehow fails'

    create :root_page, title: 'Car Catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Car Catalog'
    assert_difference 'Structure::Page.count', -1 do
      click_link 'Delete Page'
    end

    page.wont_have_content 'Car Catalog'
    # TODO: test current_section
  end

  scenario 'edit section page' do
    section = create :root_page, title: 'Car Catalog', permalink: 'car-catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Car Catalog'
    into_edit_current_page

    fill_in 'structure_page[title]', with: 'Auto Catalog'
    submit_form

    section.reload
    section.title.must_equal 'Auto Catalog'
  end

  scenario 'create child section' do
    root_page = create :root_page, title: 'Car Catalog', permalink: 'car-catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Car Catalog'
    into_form 'Basic section'

    parent_section = find('select[name="structure_page[parent_id]"]').value
    parent_section.must_equal root_page.id.to_s

    assert_difference 'Structure::Page.count', 1 do
      fill_in 'structure_page[title]', with: '4WD'
      check 'structure_page[visible]'
      submit_form
    end

    page.must_have_content '4WD'
    Structure::Page.last.parent_id.must_equal root_page.id
    current_section.text.must_equal '4WD'
  end

  scenario 'create section page with content' do
    user = create :user
    admin_login user

    into_site_structure_page
    into_form 'Basic section'

    assert_difference 'BasicSection.count', 1 do
      fill_in 'structure_page[title]', with: '4WD'
      check 'structure_page[visible]'
      fill_in 'structure_page[content_attributes][title]', with: '4WD Cars'
      fill_in 'structure_page[content_attributes][description]', with: '4Wheel Drive Hardware Cars'
      submit_form
    end

    section_page_content = Structure::Page.last.content
    section_page_content.title.must_equal '4WD Cars'
    section_page_content.description.must_equal '4Wheel Drive Hardware Cars'
  end

  scenario 'create structure of pages' do
    user = create(:user)
    admin_login user
    into_site_structure_page

    into_form 'Basic section'
    fill_in 'structure_page[title]', with: 'Car catalog'
    fill_in 'structure_page[content_attributes][title]', with: 'Car catalog'
    submit_form

    current_section.text.must_equal 'Car catalog'

    into_form 'Basic section'
    fill_in 'structure_page[title]', with: 'SVU'
    fill_in 'structure_page[content_attributes][title]', with: 'Sport utility vehicle'
    submit_form

    current_section.text.must_equal 'SVU'

    into_form 'Basic page'
    fill_in 'structure_page[title]', with: 'Jeep Compass'
    fill_in 'structure_page[content_attributes][title]', with: 'Jeep Compass'
    submit_form

    Structure::Page.find_by(slug: 'car-catalog').permalink.must_equal 'car-catalog'
    Structure::Page.find_by(slug: 'svu').permalink.must_equal 'car-catalog/svu'
    Structure::Page.find_by(slug: 'jeep-compass').permalink.must_equal 'car-catalog/svu/jeep-compass'
  end

  scenario 'change parent of content page' do
    user = create(:user)
    admin_login user

    catalog = create(:page, title: 'Car catalog', slug: 'car-catalog', permalink: 'car-catalog')
    catalog_section = create(:page, title: 'SVU', slug: 'svu', permalink: 'car-catalog/svu', parent: catalog)
    content_page = create(:page, title: 'Jeep Compass', slug: 'compass', permalink: 'car-catalog/svu/compass', parent: catalog_section)

    into_site_structure_page
    into_categorizer_page 'Car catalog'
    into_categorizer_page 'SVU'
    into_edit_content_page content_page

    select 'Car catalog', from: 'structure_page[parent_id]'
    submit_form

    Structure::Page.find_by(slug: 'car-catalog').permalink.must_equal 'car-catalog'
    Structure::Page.find_by(slug: 'svu').permalink.must_equal 'car-catalog/svu'
    Structure::Page.find_by(slug: 'compass').permalink.must_equal 'car-catalog/compass'
  end

  scenario 'change parent of section page with content page' do
    user = create(:user)
    admin_login user

    catalog = create(:page, title: 'Car catalog', slug: 'car-catalog', permalink: 'car-catalog')
    catalog_section = create(:page, title: 'SVU', slug: 'svu', permalink: 'car-catalog/svu', parent: catalog)
    create(:page, title: 'Jeep Compass', slug: 'compass', permalink: 'car-catalog/svu/compass', parent: catalog_section)

    into_site_structure_page
    into_categorizer_page 'Car catalog'
    into_categorizer_page 'SVU'
    into_edit_current_page

    select nil, from: 'structure_page[parent_id]'
    submit_form

    Structure::Page.find_by(slug: 'car-catalog').permalink.must_equal 'car-catalog'
    Structure::Page.find_by(slug: 'svu').permalink.must_equal 'svu'
    Structure::Page.find_by(slug: 'compass').permalink.must_equal 'svu/compass'
  end

  scenario 'edit content page' do
    section = create :root_page, title: 'Car Catalog', permalink: 'car-catalog'
    content = create :page, title: 'Jeep Compass', parent: section, permalink: 'car-catalog/jeep-compass'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Car Catalog'
    into_edit_content_page content

    fill_in 'structure_page[title]', with: 'Jeep Compass 2015'
    submit_form

    content.reload
    content.title.must_equal 'Jeep Compass 2015'
  end

  scenario 'delete content page' do
    skip 'test somehow fails'

    section = create :root_page, title: 'Car Catalog'
    content = create :page, title: 'Jeep Compass', parent: section
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Car Catalog'
    assert_difference 'Structure::Page.count', -1 do
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
    root_page = create :root_page, title: 'Car Catalog', permalink: 'car-catalog'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Car Catalog'
    into_form 'Basic page'

    parent_section = find('select[name="structure_page[parent_id]"]').value
    parent_section.must_equal root_page.id.to_s

    assert_difference 'Structure::Page.count', 1 do
      fill_in 'structure_page[title]', with: 'Jeep Compass'
      check 'structure_page[visible]'
      submit_form
    end

    page.must_have_content 'Jeep Compass'
    Structure::Page.last.parent_id.must_equal root_page.id
    current_section.text.must_equal 'Jeep Compass'
  end

  scenario 'create content page with content' do
    create :root_page, title: 'Information', permalink: 'information'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Information'
    into_form 'Basic page'

    assert_difference 'BasicPage.count', 1 do
      fill_in 'structure_page[title]', with: 'About company'
      check 'structure_page[visible]'
      fill_in 'structure_page[content_attributes][title]', with: 'About'
      fill_in 'structure_page[content_attributes][body]', with: 'Work in progress'
      submit_form
    end

    last_content_page_content = Structure::Page.last.content
    last_content_page_content.title.must_equal 'About'
    last_content_page_content.body.must_equal 'Work in progress'
  end

  scenario 'Cancel from Section Page form leads to this Section Page in categorizer' do
    create :root_page, title: 'Information', permalink: 'information'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Information'
    into_edit_current_page

    click_link 'Cancel'
    current_path.must_equal admin_structure_pages_path
    current_section.text.must_equal 'Information'
  end

  scenario 'Cancel from Content Page form leads to parent Section Page in categorizer' do
    section = create :root_page, title: 'Information', permalink: 'information'
    content = create :page, title: 'Some page', parent: section, permalink: 'information/some-page'
    user = create :user
    admin_login user

    into_site_structure_page
    into_categorizer_page 'Information'
    into_edit_content_page content

    click_link 'Cancel'
    current_path.must_equal admin_structure_pages_path
    current_section.text.must_equal 'Some page'
  end

  scenario 'Batch delete', js: true do
    Structure.m_configure { |config| config.menus << :catalog_menu }

    drafts_section = create(:page, title: 'Draft Sections', slug: 'drafts', permalink: 'drafts', menu: 'CatalogMenu')
    pages_to_delete = [
      create(:page, title: 'Draft 1', slug: 'draft-1', permalink: 'drafts/draft-1', parent: drafts_section, menu: 'CatalogMenu'),
      create(:page, title: 'Draft 2', slug: 'draft-2', permalink: 'drafts/draft-2', parent: drafts_section, menu: 'CatalogMenu')
    ]

    user = create(:user)
    admin_login(user)

    into_site_structure_page
    into_categorizer_page('Draft Sections')

    pages_to_delete.each do |a_page|
      check("batch_action_item_#{a_page.id}")
    end
    click_link('Batch Actions')
    click_link('Delete Selected')
    dialog_confirm

    pages_to_delete.each do |a_page|
      assert_equal false, Structure::Page.exists?(a_page.id)
      refute Structure::Page.exists?(a_page.id)
    end

    current_section.text.must_equal 'Draft Sections'
  end

end
