require 'rspec/expectations'

RSpec::Matchers.define :be_a_pause_command do
  match do |actual|
    actual[0] == 'P'
  end

  failure_message do |actual|
    "expected that #{actual} would be a mpg321 pause command ('P'/'PAUSE')"
  end
end

RSpec::Matchers.define :be_a_stop_command do
  match do |actual|
    actual[0] == 'S'
  end

  failure_message do |actual|
    "expected that #{actual} would be a mpg321 stop command ('S'/'STOP')"
  end
end

RSpec::Matchers.define :set_volume_to do |vol|
  match do |actual|
    actual == "G #{vol}"
  end

  failure_message do |actual|
    "expected that #{actual} would be a mpg321 gain command ('G'/'LOAD') with '#{vol}'"
  end
end

RSpec::Matchers.define :be_a_load_command_for do |file|
  match do |actual|
    actual == "L #{file}"
  end

  failure_message do |actual|
    "expected that #{actual} would be a mpg321 load command ('L'/'LOAD') for file '#{file}'"
  end
end
