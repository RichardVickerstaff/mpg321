Mpg321
===========

[![Build Status](https://travis-ci.org/RichardVickerstaff/mpg321.svg)](https://travis-ci.org/RichardVickerstaff/mpg321)
[![Gem Version](https://badge.fury.io/rb/mpg321.svg)](http://badge.fury.io/rb/mpg321)

A simple ruby wrapper around mpg321
-----------------------------------

Mpg321 is a wrapper for the [mpg321][mpg321] library in "Remote control" mode, which
allows to you play, pause, stop and control the volume of mp3 files from Ruby.

Installation
------------
Either:
  - Add `gem "mpg321"` to your Gemfile and run bundle install.

or

  - Run `gem install mpg321`

Usage
-----
Here's how you can easily play an mp3:

```ruby
require 'mpg321'
mog321 = Mpg321::Client.new

mpg321.play('/some_path/song.mp3') #=> to play a song from a file

mpg321.play('http://example.com/a_hosted_song.mp3') #=> to play a song from the web
```

Volume controls:

```ruby
require 'mpg321'
mog321 = Mpg321::Client.new

mpg321.volume #=> initialized to 50

mpg321.volume = 10 #=> Set volume to a number between 0 and 100

mpg321.volume_up(10)   #=> Increase volume by 10
mpg321.volume_down(10) #=> Decrease volume by 10
```
Other controls:

```ruby
require 'mpg321'
mog321 = Mpg321::Client.new

mpg321.pause #=> Pause / unpause song

mpg321.stop  #=> Stop playing song
```

Contributing
------------
  1. Make a fork
  2. Make your changes
  3. Push your changes to your fork
  4. Create a Pull Request

[mpg321]: http://linux.die.net/man/1/mpg321
