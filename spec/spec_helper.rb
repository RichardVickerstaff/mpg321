require 'mpg321'

require 'bundler/setup'
require 'simplecov'
SimpleCov.start

Dir['./spec/support/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
