require 'spec_helper'

describe Mpg321::Client do
  include_context 'fake_mpg321'

  describe 'initialize' do
    it 'sets the volume to 50' do
      expect(subject.volume).to eq 50
    end
  end

  describe '#volume_up' do
    it 'sends a message to increase the volume' do
      subject.volume_up 10
      expect(last_command).to set_volume_to 60
    end

    it 'has a maximum volume of 100' do
      subject.volume_up 55
      expect(subject.volume).to eq 100
      expect(last_command).to set_volume_to 100
    end
  end

  describe '#volume_down' do
    it 'sends a message to decrease the volume' do
      subject.volume_down 10
      expect(last_command).to set_volume_to 40
    end

    it 'has a minimum volume of 0' do
      subject.volume_down 55
      expect(subject.volume).to eq 0
      expect(last_command).to set_volume_to 0
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

    it 'casts float arguments to integer' do
      expect(subject.volume).to eq 50
      subject.volume = 47.11
      expect(subject.volume).to eq 47
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
      subject.volume = 11
      expect(last_command).to set_volume_to 11
    end
  end
end
