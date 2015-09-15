# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "munge/version"

Gem::Specification.new do |spec|
  spec.name          = "munge"
  spec.version       = Munge::VERSION
  spec.authors       = ["Zach Ahn"]
  spec.email         = ["zach.ahn@gmail.com"]

  spec.summary       = "A piping-inspired static site generator"
  spec.homepage      = "https://github.com/zachahn/munge"
  spec.license       = "MIT"

  spec.files         =
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features|script)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rubocop", "~> 0.32.1"

  spec.add_runtime_dependency "tilt", "~> 2.0.1"
end
