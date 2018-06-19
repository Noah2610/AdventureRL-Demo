module Demo
	class Game < AdventureRL::Window
		def setup args
			# #setup will be called after #initialize
			# args are the arguments that were passed to #initialize,
			# or an empty hash if none were passed
		end

		private

		def button_down btnid
			case btnid
			when Gosu::KB_Q, Gosu::KB_ESCAPE
				close
			end
		end

		def update
			#puts "#{get_fps} - #{get_deltatime}"
      puts get_deltatime * get_fps
			super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
		end
	end
end
