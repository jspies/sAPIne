# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sapine/version'

Gem::Specification.new do |spec|
  spec.name          = "sapine"
  spec.version       = Sapine::VERSION
  spec.authors       = ["Jonathan Spies"]
  spec.email         = ["jonathan.spies@gmail.com"]
  spec.summary       = %q{sAPIne adds sane defaults for a RESTful API}
  spec.description   = %q{sAPIne adds paging, ordering, limiting, etc to index}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
end
