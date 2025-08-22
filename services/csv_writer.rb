class CSVWriter
  def self.call(data, output_path)
    headers = data.flat_map(&:keys).uniq

    CSV.open(output_path, 'w') do |csv|
      csv << headers
    end
  end
end
