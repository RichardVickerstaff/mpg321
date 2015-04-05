# coding: utf-8
require File.expand_path('../lib/version', __FILE__)
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "mpg321"
  spec.version       = Mpg321::VERSION
  spec.authors       = ["Richard Vickerstaff"]
  spec.email         = ["m3akq@btinternet.com"]
  spec.description   = "A simple ruby wrapper around mpg321"
  spec.summary       = "Provides a ruby object to wrap the mpg321 'Remote control'"
  spec.homepage      = "https://github.com/RichardVickerstaff/rake-n-bake"
  spec.license       = "GNU GENERAL PUBLIC LICENSE"
  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]
end
