# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ig_scrape/version"

Gem::Specification.new do |spec|
  spec.name          = "ig_scrape"
  spec.version       = IGScrape::VERSION
  spec.authors       = ["Trevor Kimenye"]
  spec.email         = ["kimenye@gmail.com"]
  spec.executables   << 'ig_scrape'

  spec.summary       = %q{A gem to scrape instagram posts and comments}
  spec.description   = %q{A gem to scrape instagram posts and comments.}
  spec.homepage      = "https://github.com/ongair/ig_scrape"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "minitest-reporters"
  spec.add_dependency "httparty"
end
