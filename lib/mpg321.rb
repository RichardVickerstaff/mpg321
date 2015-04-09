require 'open3'

class Mpg321
  attr_reader :volume

  def initialize
    @volume = 50
    @music_input, _stdout, _stderr, _thread = Open3.popen3("mpg321 -R mpg321_ruby")
    Thread.new { loop do _stderr.readline end }
    Thread.new { loop do _stdout.readline end }
    set_volume
  end

  def pause
    @music_input.puts "P"
  end

  def stop
    @music_input.puts "S"
  end

  def play song_list
    songs = song_list.respond_to?(:join) ? song_list.join(' ') : song_list
    @music_input.puts "L #{songs}"
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
    @music_input.puts "G #{@volume}"
  end
end
