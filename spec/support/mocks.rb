require 'stringio'

class FakeReadThread
  def initialize(ctx, &block)
    @ctx    = ctx
    @action = block
  end

  def run_once
    @ctx.instance_eval &@action
  end

  def join
    self
  end
end

class FakeWaitThread
  FakeExitStatus = Struct.new(:exitstatus)

  def join
    self
  end

  def value
    FakeExitStatus.new(0)
  end
end

class FakeMpg321
  attr_reader :stdin, :stdoe, :wait_thr

  def initialize
    @stdin    = StringIO.new
    @stdoe    = StringIO.new
    @wait_thr = FakeWaitThread.new
  end

  def open2e_returns
    [@stdin, @stdoe, @wait_thr]
  end

  def last_command
    @stdin.rewind
    cmd = @stdin.gets.strip until @stdin.eof?
    @stdin = StringIO.new
    cmd
  end

  def send_status_update data
    send_mpg321_output "@F #{data[:current_frame]} #{data[:frames_remaining]} #{data[:current_time]} #{data[:time_remaining]}"
  end

  def finish_playback
    send_mpg321_output '@P 3'
  end

  def send_command_syntax_error
    send_mpg321_output "@E Missing argument to 'L'"
  end

  def send_file_not_found
    send_mpg321_output "foobar: #{Mpg321::ProcessWrapper::LOCALIZED_ENOENT_MESSAGE}"
  end

  def send_fatal_unknown_error
    send_mpg321_output 'big boom'
  end

  def send_mpg321_output(line)
    @stdoe.rewind
    @stdoe.flush
    @stdoe.puts line
    @stdoe.rewind
  end
end
