module Mpg321
  class Client
    include Control::Playback
    include Control::Volume

    extend Forwardable
    def_delegator :@process, :send_command

    def initialize
      @process = ProcessWrapper.new
      send :volume=, 50
    end
  end
end
