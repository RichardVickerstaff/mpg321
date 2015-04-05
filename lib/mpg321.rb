require 'open3'

class Mpg321
  attr_reader :volume

  def initialize
    @volume = 50
    @mus, _stdout, _stderr, _thread = Open3.popen3("mpg321 -R makey_sound")
    Thread.new { loop do _stderr.readline end }
    Thread.new { loop do _stdout.readline end }
    set_volume
  end

  def pause
    @mus.puts "P"
  end

  private def set_volume
    @mus.puts "G #{@volume}"
  end

  def play path
    @mus.puts "L #{path}"
  end

  def next
    @mus.puts "L #{@files.next.file_path}"
  end

  def previous
    @mus.puts "L #{@files.previous.file_path}"
  end

  def volume_up num
    @volume += num
    @volume = [@volume, 50].min
    set_volume
  end

  def volume_down num
    @volume -= num
    @volume = [@volume, 0].max
    set_volume
  end
end
