require 'csv'

class CSVReader
  # returns an array of hashes, each hash representing a row in the CSV
  def self.call(file_path)
    results = []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      results << row.to_h
    end
    results
  end
end
