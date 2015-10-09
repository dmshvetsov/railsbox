FactoryGirl.define do
  factory :page, class: Structure::Page do
    sequence(:title) { |n| "title ##{n}" }
  end

end
