require 'spec_helper'
require 'mpg321'

describe Mpg321 do
  describe '#volume_up' do
    it 'sends a message to increase the volume'
  end

  describe '#volume_down' do
    it 'sends a message to increase the volume'
  end

  describe '#volume' do
    it 'returns the current volume'
  end
  describe '#play' do
    it 'sends a message to play a song'
    it 'can play a list of songs'
  end
  describe '#pause' do
    it 'sends a message to pause the song'
  end
  describe '#stop' do
    it 'sends a message to stop the song'
  end

end
