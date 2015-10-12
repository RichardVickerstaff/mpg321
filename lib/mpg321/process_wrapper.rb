require 'open3'

module Mpg321
  class ProcessWrapper
    def initialize
      @stdin, @stdoe, @wait_thr = Open3.popen2e 'mpg321 -R mpg321_ruby'
      @read_thr = Thread.new { handle_stdoe }
    end

    def send_command command, *args
      @stdin.puts [command, *(args.map(&:to_s))].join(' ')
    end

    private

    def handle_stdoe
      loop do
        line = @stdoe.readline
        case line[0..1]
#        when '@R'
#        when '@I'
#        when '@S'
#        when '@F'
        when '@P'
        end
      end
    end
  end
end
