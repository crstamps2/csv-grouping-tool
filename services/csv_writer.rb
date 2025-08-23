class CSVWriter
  def self.call(data, original_headers, output_path)
    return if data.nil? || data.empty?

    final_headers = ['ID'] + original_headers
    header_to_symbol_map = original_headers.to_h { |h| [h, h.downcase.to_sym] }

    CSV.open(output_path, 'w') do |csv|
      csv << final_headers
      data.each do |row|
        output_row = [row[:id]]

        original_headers.each do |header|
          symbol_key = header_to_symbol_map[header]
          output_row << row[symbol_key]
        end
        
        csv << output_row
      end
    end
  end
end
