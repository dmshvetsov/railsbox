require 'csv'

class FasareImporter

  def initialize file, model
    @file = file
    @model = model
  end

  def import
    Upsert.batch(connection, table_name) do |upsert|
      rows.each do |r|
        r[:created_at] = r[:updated_at] = Time.now
        upsert.row({ 'external_key' => r['external_key'] }, r.to_h)
      end
    end
  end

  def connection
    @model.connection
  end

  def table_name
    @model.table_name
  end

  def rows
    CSV.read(@file, headers: true)
  end

end
