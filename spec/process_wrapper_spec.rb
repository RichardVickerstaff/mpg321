require 'spec_helper'

describe Mpg321::ProcessWrapper do
  include_context 'fake_mpg321'

  describe 'quit' do
    it 'sends a quit message' do
      subject.quit
      expect(last_command).to be_a_quit_command
    end

    it 'waits for completion of the reader thread' do
      # We expect the main thread to wait for the reader threads termination.
      expect(subject.fake_read_thread).to receive :join
      subject.quit
    end

    it 'collects the status of the mpg321 process (and does not leave zombies)' do
      expect(fake_mpg321.wait_thr).to receive :value
      subject.quit
    end

    it 'returns the exitstatus of the mpg321 process' do
      expect(subject.quit).to respond_to :exitstatus
    end
  end

  describe '(read thread)' do
    it 'dies when mpg321 exits' do
      # When mpg321 dies, the stdout pipe will go away, resulting
      # in an exception in the reader thread. We simulate this
      # here by closing the StringIO.
      fake_mpg321.stdoe.close
      expect { subject.fake_read_thread.run_once }.to raise_error IOError
    end
  end

  describe '(events)' do
    context 'when playback of a file has finished' do
      it 'notifies interested observers' do
        callback = Proc.new {}
        subject.on :playback_finished, &callback
        expect(callback).to receive :call

        fake_mpg321.finish_playback
        subject.fake_read_thread.run_once
      end
    end

    context 'when frame decoding status update is received' do
      let(:update_data) do
        { current_frame: 1, frames_remaining: 10, current_time: 1.00, time_remaining: 10.00 }
      end

      it 'notifies interested observers' do
        callback = Proc.new {}
        subject.on :status_update, &callback
        expect(callback).to receive(:call).with(update_data)

        fake_mpg321.send_status_update update_data
        subject.fake_read_thread.run_once
      end
    end
  end
end
