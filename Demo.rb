#!/usr/bin/env ruby

require 'bundler'
Bundler.setup
require 'AdventureRL'
require 'pathname'
# Development gems
require 'awesome_print'
require 'byebug'

ROOT = Pathname.new($0).realpath.dirname

module Demo
  DIR = {
    src:           ROOT.join('game/src'),
    settings:      ROOT.join('game/settings.yml'),
    data:          ROOT.join('game/data'),
    clip_configs:  ROOT.join('game/data/clip_configs'),
    audio_configs: ROOT.join('game/data/audio_configs'),
    clips:         ROOT.join('game/data/clips'),
    audio:         ROOT.join('game/data/audio')
  }

  require DIR[:src].join 'Game'
  require DIR[:src].join 'Smth'

  SETTINGS = AdventureRL::Settings.new DIR[:settings]
  #GAME     = Game.new SETTINGS.get(:window)
  GAME = Smth.new # SETTINGS.get(:window)
  GAME.show
end
