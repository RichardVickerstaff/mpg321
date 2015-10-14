require 'open3'

module Mpg321
  class ProcessWrapper
    def initialize
      spawn_mpg321

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

    # This corresponds to the system-specific "No such file or directory" message.
    # TODO: Would love to use strerror(3) instead, but Ruby doesn't expose that.
    LOCALIZED_ENOENT_MESSAGE = SystemCallError.new('', Errno::ENOENT::Errno).message.gsub(' - ', '')

    def spawn_mpg321
      @stdin, @stdoe, @wait_thr = Open3.popen2e 'mpg321 -R mpg321_ruby'
    end

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
      when '@F'
        parts = line.split(' ')
        emit :status_update, {
          current_frame:    parts[1].to_i,
          frames_remaining: parts[2].to_i,
          current_time:     parts[3].to_f,
          time_remaining:   parts[4].to_f
        }
      when '@P'
        # mpg321 sends '@P 3' when the song has finished playing.
        if line[3] == '3'
          emit :playback_finished
        end
      when '@E'
        # This is sent in case of illegal syntax, e.g. an empty string
        # as parameter to the LOAD command.
        emit :error, line.strip
      else
        # Any critical error is sent to stderr and is not preprended
        # by an @ character. mpg321 immediately exits afterwards.
        if line[0] != '@'
          if line.include? LOCALIZED_ENOENT_MESSAGE
            # Handle file not found gracefully and restart mpg321.
            @wait_thr.join
            spawn_mpg321
            emit :file_not_found
          else
            # TODO: This leaves the instance in a unusable state. Subsequent
            # calls to #send_message etc. will respond with EPIPE.
            emit :error, line.strip
          end
        end
      end
    end
  end
end
