FactoryGirl.define do
  factory :content_page, class: Structure::ContentPage do
    content { build :basic_page }
  end

end
