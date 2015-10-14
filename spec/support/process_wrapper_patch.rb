module Mpg321
  class ProcessWrapper
    attr_reader :fake_read_thread

    private

    # For testing, we do not want the read thread to be truly concurrent.
    def async_handle_stdoe
      @fake_read_thread ||= FakeReadThread.new { read_stdoe_line }
    end

    class FakeReadThread
      def initialize(&block)
        @action = block
      end

      def run_once
        @action.call
      end

      def join
        self
      end
    end
  end
end

