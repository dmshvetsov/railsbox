require 'test_helper'

describe Structure::PagesController do

  describe 'GET #show' do
    before do
      @about_content = create :basic_page, title: 'About us', body: 'Work in progress'
      @about_page = create :content_page, slug: 'about', permalink: 'about', content: @about_content
    end

    it 'respond 200' do
      get :show, permalink: 'about'
      response.status.must_equal 200
    end

    it 'assigns requested page by permalink as @page' do
      get :show, permalink: 'about'
      assert_equal @about_page, assigns(:page)
    end

    it 'assigns requested page content association as @association_model_name' do
      get :show, permalink: 'about'
      assert_equal @about_content, assigns(:basic_page)
    end

    it 'render template of content' do
      get :show, permalink: 'about'
      assert_template 'basic_pages/show'
    end

    it 'render application layout' do
      get :show, permalink: 'about'
      assert_template layout: 'layouts/application'
    end
  end

end
