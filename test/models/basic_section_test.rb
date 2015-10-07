require "test_helper"

describe BasicSection do
  let(:basic_section) { BasicSection.new }

  it "must be valid" do
    value(basic_section).must_be :valid?
  end
end
