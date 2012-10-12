class ValidatingBase
  def save
    return self.valid?
  end
  def save!
    return self.valid?
  end
  def update_attribute(name, value)
    send("#{name}=", value)
  end
  def new_record?
    true
  end
  include ActiveRecord::Validations

  def [](key)
    instance_variable_get(key)
  end

  def self.human_attribute_name(attribute_key_name)
    attribute_key_name.to_s
  end

  def attributes=(att)
    return if att.nil?
    att.stringify_keys!
    att.each { |k, v| send("#{k}=", v) }
  end

  def initialize(att = {})
    self.attributes = att
    yield self if block_given?
  end

end

