class DataProcessor
  def self.call(data, grouping_method = :email)
    context = {
      value_to_id_map: {},
      next_id: 0
    }
    
    data.map do |row|
      values = _extract_values_for_grouping(row, grouping_method)
      if values.empty?
        context[:next_id] += 1
        {id: context[:next_id]}.merge(row)
      else
        _find_or_assign_id(values, context).merge(row)
      end
    end
  end

  private_class_method

  def self._extract_values_for_grouping(row, grouping_method)
    row.filter_map do |key, value|
      if key.to_s.start_with?(grouping_method.to_s)
        value.to_s unless value.to_s.empty?
      end
    end.uniq
  end

  def self._find_or_assign_id(values, context)
    existing_id = values.map { |value| context[:value_to_id_map][value] }.compact.first
    if existing_id
      {id: existing_id}
    else
      context[:next_id] += 1
      values.each { |value| context[:value_to_id_map][value] = context[:next_id] }
      {id: context[:next_id]}
    end
  end
end
