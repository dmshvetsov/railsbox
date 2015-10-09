FactoryGirl.define do
  factory :section_page, class: Structure::SectionPage do
    sequence(:title) { |n| "title ##{n}" }
    content { build :basic_section }

    factory :root_section_page do
      parent_id nil
    end
  end

end
