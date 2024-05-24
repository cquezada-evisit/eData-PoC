require_relative 'lib/edata-system/version'

Gem::Specification.new do |spec|
  spec.name          = "edata-system"
  spec.version       = EdataSystem::VERSION
  spec.authors       = ["Christopher Quezada"]
  spec.email         = ["cquezada@evisit.com"]

  spec.summary       = %q{A data storage system for eVisit applications}
  spec.description   = %q{A gem to provide a flexible and efficient data storage system for eVisit applications, allowing the creation of data packs, definitions, and values to be associated with various entities.}
  spec.homepage      = "https://github.com/cquezada-evisit/eData-PoC"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "README.md"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"
end
