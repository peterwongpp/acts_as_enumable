# encoding: utf-8
require "spec_helper"

class User < SuperModel::Base
  def role_enum
    read_attribute(:role_enum)
  end
  def role_enum=(val)
    write_attribute(:role_enum, val)
  end
  
  extend ActsAsEnumable::ModelAdditions
  acts_as_enumable :role, %w(admin staff helper member)
  acts_as_enumable :status, %w(active inactive), default: "inactive"
end

describe ActsAsEnumable::ModelAdditions do
  it "creates a constant given the attribute name and values" do
    User.roles.should == %w(admin staff helper member)
    User.statuses.should == %w(active inactive)
  end

  it "is a testing function..." do
    User.roles.should == %w(admin staff helper member)
  end

  it "returns an array to be used for select" do
    User.roles_for_select("test.namespace").should == [{
      key: "admin", value: I18n.t("test.namespace.admin")
    }, {
      key: "staff", value: I18n.t("test.namespace.staff")
    }, {
      key: "helper", value: I18n.t("test.namespace.helper")
    }, {
      key: "member", value: I18n.t("test.namespace.member")
    }]

    User.statuses_for_select("test.namespace").should == [{
      key: "active", value: I18n.t("test.namespace.active")
    }, {
      key: "inactive", value: I18n.t("test.namespace.inactive")
    }]
  end

  it "returns the default value" do
    User.default_role.should be_nil
    User.default_status.should == "inactive"
  end

  it "returns the default value index" do
    User.default_role_enum.should be_nil
    User.default_status_enum.should == 1
  end

  it "handles value correctly" do
    user = User.new
    user.role_enum.should be_nil
    user.role.should be_nil
    user.status_enum.should == 1
    user.status.should == "inactive"

    user.role_enum = 1
    user.role_enum.should == 1
    user.role.should == "staff"
    user.status_enum = 0
    user.status_enum.should == 0
    user.status.should == "active"

    user.role = "admin"
    user.role_enum.should == 0
    user.role.should == "admin"
    user.status = "inactive"
    user.status_enum.should == 1
    user.status.should == "inactive"

    # error cases

    user.role = "not existing role"
    user.role_enum.should be_nil # as nil is the default value for role
    user.role.should be_nil
    user.status = "not existing status"
    user.status_enum.should == 1 # as 1 (i.e. inactive) is the default value for status
    user.status.should == "inactive"

    user.role_enum = 1234
    user.role_enum.should be_nil # as nil is the default value for role
    user.role.should be_nil
    user.status_enum = 1234
    user.status_enum.should == 1
    user.status.should == "inactive"
  end

  it "convert value to symbol" do
    user = User.new

    user.value_of_role(:admin).should == 0
    user.value_of_status(:inactive).should == 1
  end

  it "convert symbol to value" do
    user = User.new

    user.symbol_of_role(1).should == "staff"
    user.symbol_of_status(0).should == "active"
  end
end
