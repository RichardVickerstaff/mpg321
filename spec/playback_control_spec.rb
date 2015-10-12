require 'spec_helper'

describe Mpg321::Client do
  include_context 'fake_mpg321'

  describe '#play' do
    it 'sends a message to play a song' do
      subject.play example_file
      expect(last_command).to be_a_load_command_for example_file
    end

    context '#when paused' do
      before do
        subject.pause
      end

      it 'unpauses' do
        expect(subject.paused?).to be_truthy
        subject.stop
        expect(subject.paused?).to be_falsy
      end
    end
  end

  describe '#pause' do
    it 'sends a message to pause / unpause the song' do
      subject.pause
      expect(last_command).to be_a_pause_command
    end

    context '#when paused' do
      before do
        subject.pause
      end

      it 'unpauses' do
        expect(subject.paused?).to be_truthy
        subject.pause
        expect(subject.paused?).to be_falsy
      end
    end
  end

  describe '#stop' do
    it 'sends a message to stop the song' do
      subject.stop
      expect(last_command).to be_a_stop_command
    end

    context '#when paused' do
      before do
        subject.pause
      end

      it 'unpauses' do
        expect(subject.paused?).to be_truthy
        subject.stop
        expect(subject.paused?).to be_falsy
      end
    end
  end

  describe '#paused?' do
    it 'returns false if it is not paused' do
      expect(subject.paused?).to be_falsy
    end

    it 'returns false if it is not paused' do
      expect(subject.paused?).to be_falsy
      subject.pause
      expect(subject.paused?).to be_truthy
    end
  end

  describe '#loaded?' do
    it 'returns false if no file has been loaded for playback' do
      expect(subject.loaded?).to be_falsy
    end

    it 'returns true if a file has been loaded for playback' do
      subject.play '/some_path/file_name'
      expect(subject.loaded?).to be_truthy
    end
  end

  describe '#playing?' do
    it 'returns false if no file has been loaded' do
      expect(subject.playing?).to be_falsy
    end

    it 'returns true if a file has been loaded and playback is not paused' do
      subject.play '/some_path/file_name'
      expect(subject.playing?).to be_truthy
    end

    it 'returns false if a file has been loaded but playback is paused' do
      subject.play '/some_path/file_name'
      subject.pause
      expect(subject.playing?).to be_falsy
    end
  end

end
