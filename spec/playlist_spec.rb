require 'spec_helper'

describe Mpg321::Playlist do
  include_context 'fake_mpg321'

  let(:client) { subject.instance_variable_get(:@client) }
  let(:process) { client.instance_variable_get(:@process) }
  let(:fake_read_thread) { process.instance_variable_get(:@read_thr) }

  let(:song) { 'song' }
  let(:songs) { %w{ A B C } }

  before(:each) do
    songs.each { |s| subject.enqueue s }
  end

  after(:each) { subject.instance_variable_get(:@tracks).clear }

  describe 'enqueue' do
    it "adds a song to the playlist's back" do
      expect { subject.enqueue song }.to change { subject.entries.size }.by 1
      expect(subject.entries).to eq (songs + [song])
    end

    context 'when the autoplay flag is set' do
      let(:client2) { Mpg321::Client.new }
      subject { Mpg321::Playlist.new client: client2, autoplay: true }

      context 'and the player has not loaded a file' do
        it 'automatically starts playback' do
          expect(client2).to receive(:loaded?).and_return false
          expect(subject).to receive :advance
          subject.enqueue song
        end
      end

      context 'and the player has loaded a file' do
        it 'automatically starts playback' do
          expect(client2).to receive(:loaded?).and_return true
          expect(subject).to_not receive :advance
          subject.enqueue song
        end
      end
    end
  end

  describe 'advance' do
    context 'when the playlist contains songs' do
      it 'removes the first song from the playlist' do
        expect { subject.advance }.to change { subject.entries.size }.by -1
        expect(subject).to_not include songs.first
      end

      it 'starts playback of the next song' do
        expect(client).to receive(:play).with songs.first
        subject.advance
      end
    end

    context 'when the playlist is empty' do
      before { subject.instance_variable_get(:@tracks).clear }

      it 'stops playback of the current song if the player is loaded' do
        expect(client).to receive(:loaded?).and_return true
        expect(client).to receive :stop
        subject.advance
      end
    end
  end

  describe '(events)' do
    context 'in case of a playback_finished event' do
      it 'advances to the next track' do
        expect(subject).to receive :advance

        fake_mpg321.finish_playback
        fake_read_thread.run_once
      end
    end

    context 'in case of a file_not_found event' do
      it 'advances to the next track' do
        expect(subject).to receive :advance

        fake_mpg321.send_file_not_found
        fake_read_thread.run_once
      end
    end
  end
end
