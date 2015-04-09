require 'open3'

class Mpg321
  attr_reader :volume

  def initialize
    @volume = 50
    @mus, _stdout, _stderr, _thread = Open3.popen3("mpg321 -R mpg321_ruby")
    Thread.new { loop do _stderr.readline end }
    Thread.new { loop do _stdout.readline end }
    set_volume
  end

  def pause
    @mus.puts "P"
  end

  def stop
    @mus.puts "S"
  end

  def play song_list
    songs = song_list.respond_to?(:join) ? song_list.join(' ') : song_list
    @mus.puts "L #{songs}"
  end

  def volume_up num
    @volume += num
    @volume = [@volume, 100].min
    set_volume
  end

  def volume_down num
    @volume -= num
    @volume = [@volume, 0].max
    set_volume
  end

  private def set_volume
    @mus.puts "G #{@volume}"
  end
end
