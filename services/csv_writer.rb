class CSVWriter
  def self.call(data, output_path)
    return if data.nil? || data.empty?
    
    headers = data.flat_map(&:keys).uniq

    CSV.open(output_path, 'w') do |csv|
      csv << headers
      data.each do |row|
        csv << row.values_at(*headers)
      end
    end
  end
end
