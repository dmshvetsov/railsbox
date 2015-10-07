FactoryGirl.define do
  factory :section_page, class: Structure::SectionPage do
    content { build :basic_section }

    factory :root_section_page do
      parent_id nil
    end
  end

end
