# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_enumable/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_enumable"
  s.version     = ActsAsEnumable::VERSION
  s.authors     = ["PeterWong"]
  s.email       = ["peter@primitus.com"]
  s.homepage    = "https://github.com/peterwongpp/acts_as_enumable"
  s.summary     = %q{Provide Enum functionality for Active Record}
  s.description = %q{Enum is to choose a value from a preset list}

  s.rubyforge_project = "acts_as_enumable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "supermodel"
end
