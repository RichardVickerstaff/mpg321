require 'spec_helper'

describe Mpg321::Client do
  include_context 'fake_mpg321'

  context 'when playback of a file has finished' do
    before { subject.play example_file }

    it 'notifies interested observers' do
      callback = Proc.new {}
      subject.on :playback_finished, &callback
      expect(callback).to receive(:call)
      fake_mpg321.finish_playback
      subject.instance_variable_get(:@process).send(:read_stdoe_line)
    end
  end
end
