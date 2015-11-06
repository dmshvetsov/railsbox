require "test_helper"

describe Catalog::Section do
  let(:section) { Catalog::Section.new }

  it "must be valid" do
    value(section).must_be :valid?
  end
end
