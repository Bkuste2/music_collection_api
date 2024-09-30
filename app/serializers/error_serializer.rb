module ErrorSerializer
  def self.serialize(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash.map do |attribute|
      errors.map do |error|
        {id: attribute, title: error}
      end
    end.flatten

    json[:errors] = new_hash
    json
  end
end