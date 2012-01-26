module ActsAsEnumable
  module ModelAdditions
    def acts_as_enumable(attribute_name, enum_values, options={})
      const_set(attribute_name.to_s.pluralize.upcase, enum_values)

      class_eval <<-EOF
def self.#{attribute_name.to_s.pluralize}_for_select(i18n_namespace)
  #{attribute_name.to_s.pluralize.upcase}.map do |value|
    { key: value, value: I18n.t("\#{i18n_namespace}.\#{value}") }
  end
end
EOF

      class_eval <<-EOF
def self.default_#{attribute_name}
  #{options[:default].nil? ? "nil" : "\"#{options[:default]}\""}
end
EOF

      class_eval <<-EOF
def self.default_#{attribute_name}_enum
  #{attribute_name.to_s.pluralize.upcase}.index(self.default_#{attribute_name})
end
EOF

      define_method attribute_name do
        index = send("#{attribute_name}_enum")
        return nil if index.nil?
        self.class.const_get(attribute_name.to_s.pluralize.upcase)[index]
      end
      define_method "#{attribute_name}=" do |value|
        value_index = self.class.const_get(attribute_name.to_s.pluralize.upcase).index(value.to_s)
        send("#{attribute_name}_enum=", value_index)
      end

      define_method "#{attribute_name}_enum" do
        read_attribute(:"#{attribute_name}_enum") || self.class.send("default_#{attribute_name}_enum")
      end
      define_method "#{attribute_name}_enum=" do |value_index|
        counts = self.class.const_get(attribute_name.to_s.pluralize.upcase).count
        value_index = (0...counts).include?(value_index) ? value_index : self.class.send("default_#{attribute_name}_enum")
        write_attribute(:"#{attribute_name}_enum", value_index)
      end
    end
  end
end