require 'spec_helper'

describe Mpg321::ProcessWrapper do
  include_context 'fake_mpg321'

  let(:fake_read_thread) { subject.instance_variable_get(:@read_thr) }

  describe 'quit' do
    it 'sends a quit message' do
      subject.quit
      expect(last_command).to be_a_quit_command
    end

    it 'waits for completion of the reader thread' do
      # We expect the main thread to wait for the reader threads termination.
      expect(fake_read_thread).to receive :join
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

  describe '(error handling)' do
    context 'when a file can not be found' do
      let(:mpg321_error_msg) { "foobar: #{Mpg321::ProcessWrapper::LOCALIZED_ENOENT_MESSAGE}" }

      it 'notifies interested observers' do
        callback = Proc.new {}
        subject.on :file_not_found, &callback
        expect(callback).to receive :call

        fake_mpg321.send_mpg321_output mpg321_error_msg
        fake_read_thread.run_once
      end

      it 'respawns the dead mpg321 process' do
        expect(fake_mpg321.wait_thr).to receive(:join)
        expect(subject).to receive(:spawn_mpg321).and_return(fake_mpg321)

        fake_mpg321.send_mpg321_output mpg321_error_msg
        fake_read_thread.run_once
      end
    end

    context 'in case of a syntax error in a command' do
      let(:mpg321_error_msg) { "@E Missing argument to 'L'" }

      it 'notifies interested observers' do
        callback = Proc.new {}
        subject.on :error, &callback
        expect(callback).to receive(:call).with(mpg321_error_msg)

        fake_mpg321.send_mpg321_output mpg321_error_msg
        fake_read_thread.run_once
      end
    end

    context 'in any other error case (e.g., no sound card found)' do
      let(:mpg321_error_msg) { 'big boom' }

      it 'notifies interested observers' do
        callback = Proc.new {}
        subject.on :error, &callback
        expect(callback).to receive(:call).with(mpg321_error_msg)

        fake_mpg321.send_mpg321_output mpg321_error_msg
        fake_read_thread.run_once
      end

      # TODO: ProcessWrapper should probably remember that mpg321 is dead
      # and return some sane error message afterwards.
      it 'puts itself into a sane state'
    end
  end

  describe '(read thread)' do
    it 'dies when mpg321 exits' do
      # When mpg321 dies, the stdout pipe will go away, resulting
      # in an exception in the reader thread. We simulate this
      # here by closing the StringIO.
      fake_mpg321.stdoe.close
      expect { fake_read_thread.run_once }.to raise_error IOError
    end
  end

  describe '(events)' do
    context 'when playback of a file has finished' do
      it 'notifies interested observers' do
        callback = Proc.new {}
        subject.on :playback_finished, &callback
        expect(callback).to receive :call

        fake_mpg321.finish_playback
        fake_read_thread.run_once
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
        fake_read_thread.run_once
      end
    end
  end
end
