module Mpg321
  module Control
    module Volume
      def volume
        @volume
      end

      def volume= volume
        @volume = [0, volume.to_i, 100].sort[1]
        send_command 'G', @volume
      end

      def volume_up inc
        send :volume=, @volume + inc
      end

      def volume_down dec
        send :volume=, @volume - dec
      end
    end
  end
end
