class DataProcessor
  def self.call(data, grouping_method = :email)
    context = {
      value_to_id_map: {},
      next_id: 0
    }
    
    data.map do |row|
      value = row[grouping_method].to_s
      if value.empty?
        context[:next_id] += 1
        {id: context[:next_id]}.merge(row)
      else
        _find_or_assign_id(value, context).merge(row)
      end
    end
  end

  private_class_method

  def self._find_or_assign_id(value, context)
    if context[:value_to_id_map].key?(value)
      {id: context[:value_to_id_map][value]}
    else
      context[:next_id] += 1
      context[:value_to_id_map][value] = context[:next_id]
      {id: context[:next_id]}
    end
  end
end
