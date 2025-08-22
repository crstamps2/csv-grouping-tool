class DataProcessor
  def self.call(data, grouping_method = :email)
    context = {
      value_to_id_map: {},
      next_id: 0
    }
    
    prefixes = _prefixes_for(grouping_method)
    data.map do |row|
      values = _extract_values_for_grouping(row, prefixes)
      
      assigned_id = _find_or_assign_id(values, context)
      
      _update_map_with_id(values, assigned_id, context)
      
      { id: assigned_id }.merge(row)
    end
  end

  private_class_method

  def self._prefixes_for(grouping_method)
    case grouping_method
    when :email
      ['email']
    when :phone
      ['phone']
    when :both
      ['email', 'phone']
    else
      # Default to empty or raise an error for an invalid method
      [] 
    end
  end

  def self._extract_values_for_grouping(row, prefixes)
    row.filter_map do |key, value|
      if prefixes.any? { |prefix| key.to_s.start_with?(prefix) }
        value.to_s unless value.to_s.empty?
      end
    end.uniq
  end

  def self._find_or_assign_id(values, context)
    existing_id = values.map { |value| context[:value_to_id_map][value] }.compact.first
    if existing_id
      existing_id
    else
      context[:next_id] += 1
      context[:next_id]
    end
  end

  def self._update_map_with_id(values, assigned_id, context)
    values.each { |value| context[:value_to_id_map][value] = assigned_id }
  end
end
