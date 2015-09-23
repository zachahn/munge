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

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "fakefs", "~> 0.6"
  spec.add_development_dependency "redcarpet", "~> 3.3"
  spec.add_development_dependency "rubocop", "~> 0.32"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"

  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_runtime_dependency "tilt", "~> 2.0"
end
