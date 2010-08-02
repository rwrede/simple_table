$:.unshift File.expand_path('../lib', __FILE__)
require 'simple_table/version'

Gem::Specification.new do |s|
  s.name         = "simple_table"
  s.version      = SimpleTable::VERSION
  s.authors      = ["Sven Fuchs", "Raphaela Wrede"]
  s.email        = "raphaela.wrede@gmail.com"
  s.homepage     = "http://github.com/rwrede/simple_table"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'actionpack',    '~> 3.0.0.rc'
  s.add_dependency 'activesupport', '~> 3.0.0.rc'
  s.add_development_dependency 'gem_patching'
end