FactoryGirl.define do
  factory :section_page, class: Structure::SectionPage do

    factory :root_section_page do
      parent_id nil
    end
  end

end
