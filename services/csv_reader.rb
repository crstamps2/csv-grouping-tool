require 'csv'

class CSVReader
  # returns an array of hashes, each hash representing a row in the CSV
  def self.call(file_path)
    rows = []
    original_headers = CSV.open(file_path, 'r') { |csv| csv.first } || []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      rows << row.to_h
    end
    {rows: rows, original_headers: original_headers}
  end
end
