require "test_helper"

class Catalog::CarTest < ActiveSupport::TestCase
  def car
    @car ||= Catalog::Car.new
  end

  def test_valid
    assert car.valid?
  end
end
