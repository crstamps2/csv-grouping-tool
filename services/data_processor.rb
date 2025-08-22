class DataProcessor
  def self.call(data, grouping_method = :email)
    value_to_id_map = {}
    id = 0
    data.map do |row|
      value = row[grouping_method].to_s
      if value.empty?
        id += 1
        {id: id}.merge(row)
      elsif value_to_id_map.key?(value)
        {id: value_to_id_map[value]}.merge(row)
      else
        id += 1
        value_to_id_map[value] = id
        {id: id}.merge(row)
      end
    end
  end
end
