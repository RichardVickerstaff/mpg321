module Mpg321
  module Control
    module Playback
      def play song
        @loaded = true
        @paused = false
        send_command 'L', song
      end

      def pause
        @paused = !@paused
        send_command 'P'
      end

      def stop
        @loaded = false
        @paused = false
        send_command 'S'
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
