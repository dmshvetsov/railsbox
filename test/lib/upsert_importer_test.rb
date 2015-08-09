require 'test_helper'

class FasareImporterTest < Minitest::Test

  def setup
    file = File.new 'test/support/csv/car_data.csv'
    @subject = FasareImporter.new file
  end

  def import_inserts_data_to_db_test
    @subject.import
    assert_equal Catalog::Car.all, []
  end

end
