$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flot/rails/plus/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flot-rails-plus"
  s.version     = Flot::Rails::Plus::VERSION
  s.authors     = ["Colin Law"]
  s.email       = ["clanlaw@gmail.com"]
  s.homepage    = "https://github.com/colinl/flot-rails-plus"
  s.summary     = "Provides an Object Oriented interface into the flot javascript plotting library"
  s.description = "Provides an Object Oriented interface into the flot javascript plotting library"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  
  s.required_ruby_version = '>= 1.8.7'

  s.add_dependency "rails", ">=3.2.2"
  s.add_dependency 'flot-rails'
  s.add_dependency 'gon', '>=4.1.1'
  s.add_dependency 'coffee-rails', '>=3.2.2'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'jbuilder', '~> 2.0'
end
