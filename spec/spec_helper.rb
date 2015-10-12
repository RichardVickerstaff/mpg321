require 'mpg321'

# For testing, we do not want the read thread.
module Mpg321
  class ProcessWrapper
    private

    def async_handle_stdoe
    end
  end
end

require 'bundler/setup'
require 'simplecov'
SimpleCov.start

Dir['./spec/support/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
