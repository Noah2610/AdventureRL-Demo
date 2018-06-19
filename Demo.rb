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
    src:      ROOT.join('game/src'),
    settings: ROOT.join('game/settings.yml')
  }

  require DIR[:src].join 'Game'

  SETTINGS = AdventureRL::Settings.new DIR[:settings]
  GAME     = Game.new SETTINGS.get(:window)
  GAME.show
end
