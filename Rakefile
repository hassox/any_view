require 'rubygems'
require 'rake'

#begin
#  require 'jeweler'
#  Jeweler::Tasks.new do |gem|
#    gem.name = "any_view"
#    gem.summary = %Q{View helpers designed to work just about anywhere}
#    gem.description = %Q{View helpers with an absolute minimum of requirements}
#    gem.email = "has.sox@gmail.com"
#    gem.homepage = "http://github.com/hassox/any_view"
#    gem.authors = ["Daniel Neighman"]
#    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
#    gem.add_development_dependency "haml",          ">= 2.2.1"
#    gem.add_development_dependency "shoulda",       ">= 0"
#    gem.add_development_dependency "rack-test",     ">= 0.5.0"
#    gem.add_development_dependency "webrat",        ">= 0.5.1"
#    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
#  end
#  Jeweler::GemcutterTasks.new
#rescue LoadError
#  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
#end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  $:.unshift File.expand_path(File.dirname(__FILE__))
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "any_view #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
