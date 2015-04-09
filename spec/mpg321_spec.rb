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
    it 'sets the volume to 50' do
      expect(subject.volume).to eq 50
    end

    it 'returns the current volume' do
      subject.volume_up 5
      expect(subject.volume).to eq 55
    end
  end

  describe '#play' do
    it 'sends a message to play a song' do
      expect(stdin).to receive(:puts).with "L /some_path/file_name"
      subject.play '/some_path/file_name'
    end

    it 'can play a list of songs' do
      expect(stdin).to receive(:puts).with "L /some_path/file_name http://example.com/song"
      subject.play ['/some_path/file_name', 'http://example.com/song']
    end
  end

  describe '#pause' do
    it 'sends a message to pause / unpause the song' do
      expect(stdin).to receive(:puts).with "P"
      subject.pause
    end
  end

  describe '#stop' do
    it 'sends a message to stop the song' do
      expect(stdin).to receive(:puts).with "S"
      subject.stop
    end
  end

end
