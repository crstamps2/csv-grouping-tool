class DataProcessor
  def self.call(data)
    email_to_id_map = {}
    id = 0
    data.map do |row|
      email = row[:email]
      if email.empty?
        id += 1
        {id: id}.merge(row)
      elsif email_to_id_map.key?(email)
        {id: email_to_id_map[email]}.merge(row)
      else
        id += 1
        email_to_id_map[email] = id
        {id: id}.merge(row)
      end
    end
  end
end
