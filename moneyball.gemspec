# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moneyball/version'

Gem::Specification.new do |spec|
  spec.name          = "moneyball"
  spec.version       = Moneyball::VERSION
  spec.authors       = ["Geoff Harcourt"]
  spec.email         = ["geoff.harcourt@gmail.com"]

  spec.summary       = %q{A parser for Gameday XML play descriptions.}
  spec.description   = %q{Moneyball parses Gameday play-by-play descriptions and extracts usable data from plain English summaries of plays.}
  spec.homepage      = "https://github.com/geoffharcourt/moneyball"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2.0"
end
