module Mpg321
  class Client
    include Control::Playback
    include Control::Volume

    def initialize
      @music_input, @stdout, @stderr, _thread = Open3.popen3("mpg321 -R mpg321_ruby")
      handle_stderr
      handle_stdout
      send :volume=, 50
    end


    private

    def handle_stderr
      Thread.new do
        loop do

          #Not sure how to test this yet
          begin
            Timeout::timeout(1) { @stderr.readline }
          rescue Timeout::Error
          end

        end
      end
    end

    def handle_stdout
      Thread.new do
        loop do
          #Not sure how to test this yet
          @stout.readline
        end
      end
    end
  end
end
