require "test_helper"

describe BasicPage do
  let(:basic_page) { BasicPage.new }

  it "must be valid" do
    value(basic_page).must_be :valid?
  end
end
