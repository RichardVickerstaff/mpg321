require 'open3'

module Mpg321
  class ProcessWrapper
    def initialize
      @stdin, @stdoe, @wait_thr = Open3.popen2e 'mpg321 -R mpg321_ruby'

      @callbacks = Hash.new { |h, e| h[e] = Array.new }
      @read_thr  = async_handle_stdoe
    end

    def send_command command, *args
      @stdin.puts [command, *(args.map(&:to_s))].join(' ')
    end

    def on(event, &block)
      @callbacks[event] << block
    end

    def quit
      send_command 'Q'
      @read_thr.join
      @wait_thr.value
    end

    private

    def emit(event, *args)
      @callbacks[event].each { |cb| cb.call *args }
    end

    def async_handle_stdoe
      Thread.new do
        begin
          loop { read_stdoe_line }
        rescue EOFError
          # Stream exhausted, ignore.
        end
      end
    end

    def read_stdoe_line
      line = @stdoe.readline
      case line[0..1]
      # TODO: handle @F & co.
      when '@P'
        # mpg321 sends '@P 3' when the song has finished playing.
        if line[3] == '3'
          emit :playback_finished
        end
      end
    end
  end
end
