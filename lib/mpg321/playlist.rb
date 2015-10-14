module Mpg321
  class Playlist
    include Enumerable

    PLAYLIST_ADVANCE_EVENTS = [ :playback_finished, :file_not_found ]

    def initialize autoplay: false, client: Client.new
      @tracks   = Array.new
      @access   = Mutex.new
      @autoplay = autoplay
      @client   = client

      PLAYLIST_ADVANCE_EVENTS.each do |event|
        @client.on(event) { advance }
      end
    end

    def enqueue song
      @access.synchronize { @tracks << song }
      advance if @autoplay && !@client.loaded?
    end

    def advance
      if song = dequeue
        @client.play song
      else
        @client.stop if @client.loaded?
      end
    end

    def each &block
      @access.synchronize { @tracks.each &block }
    end

    private

    def dequeue
      @access.synchronize { @tracks.shift }
    end
  end
end
