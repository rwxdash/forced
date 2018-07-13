$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "forced/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "forced"
  s.version     = Forced::VERSION
  s.authors     = ["aoozdemir"]
  s.email       = ["aoozdemir@live.com"]
  s.homepage    = "https://github.com/aoozdemir/forced"
  s.summary     = "Easy force update control for Rails APIs that support mobile clients."
  s.description = "Easy force update control for APIs that support mobile clients."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "annotate"
end
