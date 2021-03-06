require File.expand_path('../lib/mpg321/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'mpg321'
  spec.version       = Mpg321::VERSION
  spec.authors       = ['Richard Vickerstaff']
  spec.email         = ['m3akq@btinternet.com']
  spec.description   = 'A simple ruby wrapper around mpg321'
  spec.summary       = "Provides a ruby object to wrap the mpg321 'Remote control'"
  spec.homepage      = 'https://github.com/RichardVickerstaff/mpg321'
  spec.license       = 'GPL-2.0'
  spec.files         = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb'] + ['LICENSE', 'README.md', 'history.rdoc']
end
