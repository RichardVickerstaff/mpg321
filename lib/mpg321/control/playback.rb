module Mpg321
  module Control
    module Playback
      def play song
        @loaded = true
        @paused = false
        @music_input.puts "L #{song}"
      end

      def pause
        @paused = !@paused
        @music_input.puts 'P'
      end

      def stop
        @loaded = false
        @paused = false
        @music_input.puts 'S'
      end

      def paused?
        !!@paused
      end

      def loaded?
        !!@loaded
      end

      def playing?
        loaded? && !paused?
      end
    end
  end
end
