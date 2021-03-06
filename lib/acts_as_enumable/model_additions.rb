module ActsAsEnumable
  module ModelAdditions
    # To make the attribute an enum.
    #
    #   class User < ActiveRecord::Base
    #     # assumes the column exists:
    #     #   integer :role_enum
    #
    #     acts_as_enumable(:role, %w(admin staff helper member), defaul: "member")
    #   end
    #
    # Available options are:
    #
    #   (optional) default: String / Symbol
    #     default value, will be set to nil if it is not provided or it does not match the preset list
    #     eg.
    #     acts_as_enumable :role, %w(admin staff), default: :something_not_exist # set the default value to nil
    #     acts_as_enumable :role, %w(admin staff), default: "staff" # set the defaut value to "staff"
    #
    # This enables the following methods:
    #
    #   user = User.first
    #   User.roles
    #   # ["admin", "staff", "helper", "member"]
    #
    #   User.roles_for_select("users.roles")
    #   # [
    #   #   { key: "admin", value: I18n.t("users.roles.admin") },
    #   #   { key: "staff", value: I18n.t("users.roles.staff") }, ...
    #   # ]
    #
    #   User.default_role
    #   # "member"
    #
    #   User.default_role_enum
    #   # 3
    #
    #   user.role
    #   # "member"
    #
    #   user.role = "staff" # or user.role = :staff
    #   user.role
    #   # "staff"
    #
    #   user.role_enum # if user.role == "staff"
    #   # 1
    #
    #   user.role_enum = 0
    #   user.role
    #   # "admin"
    def acts_as_enumable(attribute_name, enum_values, options={})
      attribute = attribute_name.to_s
      options[:default] ||= nil

      class_eval %Q{
        def self.#{attribute.pluralize}
          #{enum_values}
        end
      }

      class_eval %Q{
        def self.#{attribute.pluralize}_for_select(i18n_namespace)
          #{attribute.pluralize}.map do |value|
            { key: value, value: I18n.t("\#{i18n_namespace}.\#{value}") }
          end
        end
      }

      class_eval %Q{
        def self.default_#{attribute}
          #{options[:default].nil? ? "nil" : "\"#{options[:default]}\""}
        end
      }

      class_eval %Q{
        def self.default_#{attribute}_enum
          #{attribute.pluralize}.index(default_#{attribute})
        end
      }

      define_method "value_of_#{attribute}" do |symbol|
        self.class.send(attribute.pluralize).index(symbol.to_s)
      end

      define_method "symbol_of_#{attribute}" do |value|
        self.class.send(attribute.pluralize)[value]
      end

      define_method attribute_name do
        value = send("#{attribute_name}_enum")
        return nil if value.nil?
        self.class.send(attribute.pluralize)[value]
      end
      define_method "#{attribute_name}=" do |symbol|
        value = self.send("value_of_#{attribute}", symbol)
        send("#{attribute_name}_enum=", value)
      end

      define_method "#{attribute_name}_enum" do
        read_attribute(:"#{attribute_name}_enum") || self.class.send("default_#{attribute_name}_enum")
      end
      define_method "#{attribute_name}_enum=" do |value_index|
        counts = self.class.send(attribute.pluralize).count
        value_index = (0...counts).include?(value_index) ? value_index : self.class.send("default_#{attribute_name}_enum")
        write_attribute(:"#{attribute_name}_enum", value_index)
      end
    end
  end
end