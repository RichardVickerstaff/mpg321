require 'spec_helper'
require 'mpg321'

describe Mpg321 do

  let(:thread) { double :thread }
  let(:stderr) { double :stderr }
  let(:stdout) { double :stdout }
  let(:stdin)  { double :stdin  }

  before do
    allow(Open3).to receive(:popen3).and_return([stdin, stdout, stderr, thread])
    allow(stdin).to receive(:puts)
  end

  describe 'initialize' do
    it 'sets the volume to 50' do
      expect(subject.volume).to eq 50
    end
  end

  describe '#volume_up' do
    it 'sends a message to increase the volume' do
      expect(stdin).to receive(:puts).with "G 60"
      subject.volume_up 10
    end

    it 'has a maximum volume of 100' do
      expect(stdin).to receive(:puts).with "G 100"
      subject.volume_up 55
      expect(subject.volume).to eq 100
    end
  end

  describe '#volume_down' do
    it 'sends a message to decrease the volume' do
      expect(stdin).to receive(:puts).with "G 40"
      subject.volume_down 10
    end

    it 'has a minimum volume of 0' do
      expect(stdin).to receive(:puts).with "G 0"
      subject.volume_down 55
      expect(subject.volume).to eq 0
    end
  end

  describe '#volume' do
    it 'returns the current volume' do
      expect(subject.volume).to eq 50
      subject.volume_up 5
      expect(subject.volume).to eq 55
    end
  end

  describe '#volume=' do
    it 'sets the volume' do
      expect(subject.volume).to eq 50
      subject.volume = 11
      expect(subject.volume).to eq 11
    end

    it 'has a minimum of 0' do
      subject.volume = -1
      expect(subject.volume).to eq 0
    end

    it 'has a maximum of 100' do
      subject.volume = 101
      expect(subject.volume).to eq 100
    end

    it 'sends a message to set the volume' do
      expect(stdin).to receive(:puts).with "G 11"
      subject.volume = 11
    end
  end

  describe '#play' do
    context 'when there is only one song' do
      it 'sends a message to play a song' do
        expect(stdin).to receive(:puts).with "L /some_path/file_name"
        subject.play '/some_path/file_name'
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

    context 'when there moer than one song' do
      it 'sends a message to play the first song' do
        expect(stdin).to receive(:puts).with "L /some_path/file_name"
        subject.play ['/some_path/file_name', '/some_other_song']
      end
    end
  end

  describe '#pause' do
    it 'sends a message to pause / unpause the song' do
      expect(stdin).to receive(:puts).with "P"
      subject.pause
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
      expect(stdin).to receive(:puts).with "S"
      subject.stop
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

end
