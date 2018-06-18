#!/usr/bin/env ruby

#require 'bundler'
#Bundler.setup
require 'pathname'
# Development gems
require 'awesome_print'
require 'byebug'

ROOT = Pathname.new($0).realpath.dirname
require ROOT.join 'framework/Framework'  # AdventureRL Framework

module Demo
	DIR = {
		src:      ROOT.join('game/src'),
		settings: ROOT.join('game/settings.yml')
	}

	require DIR[:src].join 'Game'

	SETTINGS = AdventureRL::Settings.new DIR[:settings]
	GAME     = Game.new
	GAME.show
end
