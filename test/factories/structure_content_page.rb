FactoryGirl.define do
  factory :content_page, class: Structure::ContentPage do
    sequence(:title) { |n| "title ##{n}" }
    content { build :basic_page }
    menu 'MainMenu'

    factory :root_content_page do
      parent nil
    end
  end

end
