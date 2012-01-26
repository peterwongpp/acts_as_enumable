# ActsAsEnumable

Provide Enum functionality for Active Record.

## Installation

Add the following line to your Gemfile and run `bundle` command to install it.

``` ruby
gem 'acts_as_enumable'
```

*Requires Ruby 1.9.2 or later.*

## Usage

Call `acts_as_enumable` in an Active Record class and pass the name of the attribute as well as the enum values (and optionally a default value).

``` ruby
class User < ActiveRecord::Base
  # assumes the column exists:
  #   integer :role_enum

  acts_as_enumable :role, %w(admin staff helper member), default: :member
end
```

Available options are:

``` text
(optional) default: String / Symbol
# default value, will be set to nil if it is not provided or it does not match the preset list
# eg.
# acts_as_enumable :role, %w(admin staff), default: :something_not_exist # set the default value to nil
# acts_as_enumable :role, %w(admin staff), default: "staff" # set the defaut value to "staff"
```

This enables the following methods:

``` ruby
user = User.first
    
User::ROLES
# ["admin", "staff", "helper", "member"]
    
User.roles_for_select("users.roles")
# [
#   { key: "admin", value: I18n.t("users.roles.admin") },
#   { key: "staff", value: I18n.t("users.roles.staff") }, ...
# ]
    
User.default_role
# "member"
    
User.default_role_enum
# 3
    
user.role
# "member"
    
user.role = "staff" # or user.role = :staff
user.role
# "staff"
    
user.role_enum # if user.role == "staff"
# 1
    
user.role_enum = 0
user.role
# "admin"
```
## Development

If you have any problems, please post them on the [issue tracker](https://github.com/peterwongpp/acts_as_enumable/issues).

You can contribute changes by forking the project and submitting a pull request.

You can ensure the tests passing by running bundle and rake.
