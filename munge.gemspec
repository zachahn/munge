# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "munge/version"

Gem::Specification.new do |spec|
  spec.name = "munge"
  spec.version = Munge::VERSION
  spec.authors = ["Zach Ahn"]
  spec.email = ["engineering@zachahn.com"]

  spec.summary = "Static site generator aiming to simplify complex build rules"
  spec.description =
    "== Documentation\n" \
    "\n" \
    "Documentation for this release is located in " \
    "https://github.com/zachahn/munge/blob/v#{Munge::VERSION}/README.md"
  spec.homepage = "https://github.com/zachahn/munge"
  spec.license = "MIT"

  spec.files =
    Dir.chdir(File.expand_path("..", __FILE__)) do
      `git ls-files -z`
        .split("\x0")
        .select { |f| f =~ %r{^(?:exe/|lib/|seeds/|munge.gemspec|README|LICENSE|Gemfile)} }
    end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.0"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-bisect", "~> 1.3"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "fakefs", "~> 0.6"
  spec.add_development_dependency "pry-byebug", "~> 3.3"
  spec.add_development_dependency "redcarpet", "~> 3.3"
  spec.add_development_dependency "rubocop", "~> 0.32"
  spec.add_development_dependency "timecop", "~> 0.8"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"
  spec.add_development_dependency "simplecov", "~> 0.10"
  spec.add_development_dependency "yard", "~> 0.9.0"

  spec.add_runtime_dependency "adsf", "~> 1.2"
  spec.add_runtime_dependency "listen", "~> 3.0", "< 3.1"
  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_runtime_dependency "rainbow", ">= 1.99.1", "< 3.0"
  spec.add_runtime_dependency "tilt", "~> 2.0"
  spec.add_runtime_dependency "sass", "~> 3.4"
  spec.add_runtime_dependency "fixer_upper", "~> 0.5.0"

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.2.2")
    spec.add_runtime_dependency "reel", "~> 0.6"
  end

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.3")
    spec.add_runtime_dependency "rack", ">= 1.0", "< 2.0"
  end
end
