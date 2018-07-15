#!/usr/bin/env ruby

#require 'bundler'
#Bundler.setup
require 'pathname'
# Development gems
#require 'awesome_print'
require 'byebug'

ROOT = Pathname.new($0).realpath.dirname

require ROOT.join '../AdventureRL/lib/AdventureRL.rb'

module Demo
  DIR = {
    src:           ROOT.join('game/src'),
    settings:      ROOT.join('game/settings.yml'),
    data:          Pathname.new('./data'),
    clip_configs:  Pathname.new('./data/clip_configs'),
    audio_configs: Pathname.new('./data/audio_configs'),
    clips:         Pathname.new('./data/clips'),
    audio:         Pathname.new('./data/audio')
  }

  require DIR[:src].join 'Game'
  require DIR[:src].join 'Smth'

  SETTINGS = AdventureRL::Settings.new DIR[:settings]
  #GAME     = Game.new SETTINGS.get(:window)
  GAME = Smth.new # SETTINGS.get(:window)
  GAME.show
end
