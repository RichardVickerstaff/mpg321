require 'open3'

class Mpg321
  attr_reader :volume

  def initialize
    @volume = 50
    @music_input, _stdout, _stderr, _thread = Open3.popen3("mpg321 -R mpg321_ruby")
    Thread.new { loop do _stderr.readline end }
    Thread.new { loop do _stdout.readline end }
    send_volume
  end

  def pause
    @music_input.puts "P"
  end

  def stop
    @music_input.puts "S"
  end

  def play song
    @music_input.puts "L #{song}"
  end

  def volume_up volume
    @volume += volume
    @volume = [@volume, 100].min
    send_volume
  end

  def volume_down volume
    @volume -= volume
    @volume = [@volume, 0].max
    send_volume
  end

  def volume= volume
    if volume < 0
      @volume = 0
    elsif volume > 100
      @volume = 100
    else
      @volume = volume
    end
    send_volume
  end

  private

  def send_volume
    @music_input.puts "G #{@volume}"
  end
end
