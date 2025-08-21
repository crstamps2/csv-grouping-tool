require 'csv'

class CSVProcessor
  def initialize(file_path)
    @file_path = file_path
  end

  # returns an array of hashes, each hash representing a row in the CSV
  def rows
    results = []
    CSV.foreach(@file_path, headers: true, header_converters: :symbol) do |row|
      results << row.to_h
    end
    results
  end
end
