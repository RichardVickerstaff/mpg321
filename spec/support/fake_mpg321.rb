require 'stringio'

class FakeMpg321
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

  private

  class FakeWaitThread
  end
end
