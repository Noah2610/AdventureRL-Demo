#require 'bundler'
#Bundler.setup
require 'gosu'
require 'pathname'
require 'yaml'

module AdventureRL
	entry = Pathname.new(__FILE__).realpath
	ROOT  = entry.dirname
	DIR   = {
		entry:      entry,
		src:        ROOT.join('src'),
		misc:       ROOT.join('src/misc'),
		settings:   ROOT.join('settings.yml')
	}
	require DIR[:misc].join 'extensions'
	require DIR[:src].join 'ErrorHelper'
	require DIR[:src].join 'Settings'
	SETTINGS = Settings.new DIR[:settings]
end
