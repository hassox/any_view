# -*- encoding: utf-8 -*-

require 'bundler'

Gem::Specification.new do |s|
  s.name = %q{any_view}
  s.version = "0.2.0pre"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Neighman"]
  s.date = %q{2009-12-13}
  s.description = %q{View helpers with an absolute minimum of requirements}
  s.summary = %q{View helpers designed to work just about anywhere}
  s.homepage = %q{http://github.com/hassox/any_view}
  s.email = %q{has.sox@gmail.com}
  s.files = Dir[File.join(Dir.pwd, "**/*")]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}

  s.add_bundler_dependencies
end



