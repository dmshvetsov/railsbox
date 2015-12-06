FactoryGirl.define do
  factory :page, class: Structure::Page do
    sequence(:title) { |n| "title ##{n}" }
    content { build :basic_section }
    menu 'MainMenu'
    language 'en'

    factory :root_page do
      parent_id nil
    end
  end

end
